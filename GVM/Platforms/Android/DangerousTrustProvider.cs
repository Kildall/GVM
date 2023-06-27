using Java.Security;
using Javax.Net.Ssl;
using Java.Net;
using Java.Security.Cert;

namespace GVM.Platforms.Android {
    /// <summary>
    /// https://github.com/dotnet/SqlClient/issues/1656#issuecomment-1355500465
    /// </summary>
    internal class DangerousTrustProvider : Provider {
        private const string TRUST_PROVIDER_ALG = "DangerousTrustAlgorithm";
        private const string TRUST_PROVIDER_ID = "DangerousTrustProvider";

        public DangerousTrustProvider() : base(TRUST_PROVIDER_ID, 1, string.Empty) {
            var key = "TrustManagerFactory." + DangerousTrustManagerFactory.GetAlgorithm();
            var val = Java.Lang.Class.FromType(typeof(DangerousTrustManagerFactory)).Name;
            Put(key, val);
        }

        public static void Register() {
            Provider registered = Java.Security.Security.GetProvider(TRUST_PROVIDER_ID);
            if (null == registered) {
                Java.Security.Security.InsertProviderAt(new DangerousTrustProvider(), 1);
                Java.Security.Security.SetProperty("ssl.TrustManagerFactory.algorithm", TRUST_PROVIDER_ALG);
            }
        }

        public class DangerousTrustManager : X509ExtendedTrustManager {
            public override void CheckClientTrusted(X509Certificate[] chain, string authType, Socket socket) { }
            public override void CheckClientTrusted(X509Certificate[] chain, string authType, SSLEngine engine) { }
            public override void CheckClientTrusted(X509Certificate[] chain, string authType) { }
            public override void CheckServerTrusted(X509Certificate[] chain, string authType, Socket socket) { }
            public override void CheckServerTrusted(X509Certificate[] chain, string authType, SSLEngine engine) { }
            public override void CheckServerTrusted(X509Certificate[] chain, string authType) { }
            public override X509Certificate[] GetAcceptedIssuers() => Array.Empty<X509Certificate>();
        }

        public class DangerousTrustManagerFactory : TrustManagerFactorySpi {
            protected override void EngineInit(IManagerFactoryParameters mgrparams) { }
            protected override void EngineInit(KeyStore keystore) { }
            protected override ITrustManager[] EngineGetTrustManagers() => new ITrustManager[] { new DangerousTrustManager() };
            public static string GetAlgorithm() => TRUST_PROVIDER_ALG;
        }
    }
}