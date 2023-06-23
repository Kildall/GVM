using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore;
using Blazorise;
using Blazorise.Bootstrap5;
using Blazorise.Icons.FontAwesome;
using GVM.Data;
using System.Reflection;
using System.Resources;

namespace GVM
{
    public static class MauiProgram
    {
        public static MauiApp CreateMauiApp()
        {
            var builder = MauiApp.CreateBuilder();
            builder.UseMauiApp<App>().ConfigureFonts(fonts =>
            {
                fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
            });
            ResourceManager rm = new ResourceManager("GVM.Properties.Resources", Assembly.GetExecutingAssembly());
            string connectionString = rm.GetString("GVMConnectionString");
            builder.Services.AddDbContext<GVMContext>(options => options.UseSqlServer(connectionString));

            builder.Services.AddBlazorise(options => { options.Immediate = true; })
                    .AddBootstrap5Providers()
                    .AddFontAwesomeIcons();

            builder.Services.AddMauiBlazorWebView();
#if DEBUG
            builder.Services.AddBlazorWebViewDeveloperTools();
            builder.Logging.AddDebug();
#endif

            return builder.Build();
        }
    }
}

