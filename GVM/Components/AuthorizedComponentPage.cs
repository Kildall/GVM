using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using GVM.Data;
using GVM.Services;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Routing;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

namespace GVM.Components {
    public class AuthorizedComponentPage : ComponentBase, IDisposable {
        [Inject]
        public NavigationManager NavigationManager { get; set; }

        [Inject]
        public IMapper Mapper { get; set; }

        [Inject]
        public APIService ApiService { get; set; }

        private IDisposable? _registration;

        protected override void OnInitialized() {
            base.OnInitialized();
            ApiService.SessionExpired += OnSessionExpired;
        }

        protected override void OnAfterRender(bool firstRender) {
            if (firstRender) {
                _registration = NavigationManager.RegisterLocationChangingHandler(OnLocationChanging);
            }
        }

        private ValueTask OnLocationChanging(LocationChangingContext context) {
            return ValueTask.CompletedTask;
        }

        private void OnSessionExpired(object sender, EventArgs e) {
            InvokeAsync(() => {
                NavigationManager.NavigateTo("/login", forceLoad: true);
            });
        }

        public void Dispose() {
            _registration?.Dispose();
            ApiService.SessionExpired -= OnSessionExpired;
        }
    }
}