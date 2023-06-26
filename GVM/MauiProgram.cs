using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore;
using Blazorise;
using Blazorise.Bootstrap5;
using Blazorise.Icons.FontAwesome;
using GVM.Data;
using System.Reflection;
using System.Resources;
using GVM.Security;
using GVM.Services;

namespace GVM {
    public static class MauiProgram {
        public static MauiApp CreateMauiApp() {
            try {
                var builder = MauiApp.CreateBuilder();
                builder.UseMauiApp<App>().ConfigureFonts(fonts => {
                    fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
                });
                ResourceManager rm = new ResourceManager("GVM.Properties.Resources", Assembly.GetExecutingAssembly());

                string seguridadCs = rm.GetString("GVMSeguridadConnectionString");
                string gvmCs = rm.GetString("GVMConnectionString");
                builder.Services.AddDbContext<GVMContext>(options => options.UseSqlServer(gvmCs));
                builder.Services.AddDbContext<SeguridadContext>(options => options.UseSqlServer(seguridadCs));

                builder.Services.AddSingleton<SeguridadService>();
                builder.Services.AddBlazorise(options => { options.Immediate = true; })
                    .AddBootstrap5Providers()
                    .AddFontAwesomeIcons();

                builder.Services.AddMauiBlazorWebView();
#if DEBUG
                builder.Services.AddBlazorWebViewDeveloperTools();
                builder.Logging.AddDebug();
#endif
#if ANDROID
                Platforms.Android.DangerousTrustProvider.Register();
#endif
                return builder.Build();
            } catch (Exception e) {
                Console.WriteLine(e);
                throw;
            }
        }
    }
}

