using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Timers;
using GVM.Data.Response;
using Timer = System.Timers.Timer;

namespace GVM.Services {
    public class APIService : IDisposable {
        private readonly HttpClient _httpClient;
        private string _jwtToken;
        private DateTime _tokenExpiration;
        private readonly Timer _expirationTimer;
        private readonly JsonSerializerOptions _jsonOptions;

        public event EventHandler SessionExpired;

        public APIService(string baseUrl) {
            _httpClient = new HttpClient {
                BaseAddress = new Uri(baseUrl)
            };

            _expirationTimer = new Timer(30000); // 30 seconds
            _expirationTimer.Elapsed += CheckSessionExpiration;
            _expirationTimer.AutoReset = true;

            _jsonOptions = new JsonSerializerOptions {
                PropertyNameCaseInsensitive = true
            };
        }

        public async Task<bool> LoginAsync(string username, string password) {
            var loginData = new { Username = username, Password = password };
            var response = await _httpClient.PostAsJsonAsync("api/login", loginData);

            if (response.IsSuccessStatusCode) {
                var content = await response.Content.ReadAsStringAsync();
                var loginResponse = JsonSerializer.Deserialize<LoginResponse>(content, _jsonOptions);

                if (loginResponse.status.success) {
                    _jwtToken = loginResponse.data.token;
                    _tokenExpiration = loginResponse.data.expires;
                    _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _jwtToken);

                    // Start the expiration timer
                    _expirationTimer.Start();

                    return true;
                }
            }

            return false;
        }

        public async Task<T> GetAsync<T>(string endpoint) where T : class {
            return await SendRequestAsync<T>(HttpMethod.Get, endpoint);
        }

        public async Task<T> PostAsync<T>(string endpoint, object data) where T : class {
            return await SendRequestAsync<T>(HttpMethod.Post, endpoint, data);
        }

        public async Task<T> PutAsync<T>(string endpoint, object data) where T : class {
            return await SendRequestAsync<T>(HttpMethod.Put, endpoint, data);
        }

        public async Task DeleteAsync(string endpoint) {
            await SendRequestAsync<object>(HttpMethod.Delete, endpoint);
        }

        private async Task<T> SendRequestAsync<T>(HttpMethod method, string endpoint, object data = null) where T : class {
            if (IsSessionExpired()) {
                OnSessionExpired();
                throw new UnauthorizedAccessException("Session has expired. Please login again.");
            }

            var request = new HttpRequestMessage(method, endpoint);

            if (data != null) {
                request.Content = JsonContent.Create(data, options: _jsonOptions);
            }

            var response = await _httpClient.SendAsync(request);

            if (response.StatusCode == System.Net.HttpStatusCode.Unauthorized) {
                OnSessionExpired();
                throw new UnauthorizedAccessException("Session is no longer valid. Please login again.");
            }

            response.EnsureSuccessStatusCode();

            var content = await response.Content.ReadAsStringAsync();
            var apiResponse = JsonSerializer.Deserialize<Response>(content, _jsonOptions);

            if (!apiResponse.status.success) {
                throw new Exception($"API request failed: {string.Join(", ", apiResponse.status.errors)}");
            }

            return JsonSerializer.Deserialize<T>(apiResponse.data.ToString(), _jsonOptions);
        }

        private bool IsSessionExpired() {
            return string.IsNullOrEmpty(_jwtToken) || DateTime.UtcNow >= _tokenExpiration;
        }

        private void OnSessionExpired() {
            _expirationTimer.Stop();
            SessionExpired?.Invoke(this, EventArgs.Empty);
        }

        private void CheckSessionExpiration(object sender, ElapsedEventArgs e) {
            if (IsSessionExpired()) {
                OnSessionExpired();
            }
        }

        public void Dispose() {
            _expirationTimer.Dispose();
            _httpClient.Dispose();
        }
    }
}