using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore;
using System.Reflection;
using System.Resources;
using Blazorise;
using Blazorise.Bootstrap5;
using Blazorise.Icons.FontAwesome;
using GVM.Data;
using Microsoft.Extensions.Configuration;

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
            SecureStorageHelper.SaveConnectionStringAsync().Wait();
            string connectionString = SecureStorageHelper.GetConnectionStringAsync().Result;
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

