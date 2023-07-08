using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore;
using GVM.Data;
using System.Reflection;
using System.Resources;
using GVM.Security;
using GVM.Services;
using GVM.Utils.Profiler;
using MudBlazor.Services;

namespace GVM {
    public static class MauiProgram {
        public static MauiApp CreateMauiApp() {
            var builder = MauiApp.CreateBuilder();
            builder.UseMauiApp<App>()
                .ConfigureFonts(fonts => {
                    fonts.AddFont("DMSans-Regular.ttf", "DMSansRegular");
                    fonts.AddFont("DMSans-Medium.ttf", "DMSansMedium");
                    fonts.AddFont("DMSans-Bold.ttf", "DMSansBold");
                });
            ResourceManager rm = new ResourceManager("GVM.Properties.Resources", Assembly.GetExecutingAssembly());

            string seguridadCs = rm.GetString("GVMSeguridadConnectionString");
            string gvmCs = rm.GetString("GVMConnectionString");

            builder.Services.AddDbContext<GVMContext>(options => options.UseLazyLoadingProxies()
                .UseSqlServer(gvmCs, sqlServerOptions => sqlServerOptions.EnableRetryOnFailure()));

            builder.Services.AddDbContext<SeguridadContext>(options => options.UseLazyLoadingProxies()
                .UseSqlServer(seguridadCs, sqlServerOptions => sqlServerOptions.EnableRetryOnFailure()));

            builder.Services.AddSingleton<SeguridadService>();

            builder.Services.AddMauiBlazorWebView();
            builder.Services.AddMudServices();
            builder.Services.AddAutoMapper(typeof(MappingProfiles));
#if DEBUG
            builder.Services.AddBlazorWebViewDeveloperTools();
            builder.Logging.AddDebug();
#endif
#if ANDROID
            Platforms.Android.DangerousTrustProvider.Register();
#endif
            return builder.Build();
        }
    }
}

