using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore;
using GVM.Data;
using System.Reflection;
using System.Resources;
using GVM.Services;
using GVM.Utils.Profiler;
using MudBlazor.Services;
using MudBlazor;
using Microsoft.Extensions.DependencyInjection;

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

            // Add APIService as a singleton
            builder.Services.AddSingleton(sp => new APIService(rm.GetString("API_URL")));

            builder.Services.AddMauiBlazorWebView();
            builder.Services.AddMudServices(config => {
                config.SnackbarConfiguration.PositionClass = Defaults.Classes.Position.BottomCenter;
                config.SnackbarConfiguration.VisibleStateDuration = 3000;
                config.SnackbarConfiguration.HideTransitionDuration = 200;
                config.SnackbarConfiguration.ShowTransitionDuration = 200;
            });
            builder.Services.AddAutoMapper(typeof(MappingProfiles));
#if DEBUG
            builder.Services.AddBlazorWebViewDeveloperTools();
            builder.Logging.AddDebug();
#endif
            return builder.Build();
        }
    }
}

