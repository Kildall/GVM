using Microsoft.Extensions.Logging;
using GVM.Data;
using Blazorise;
using Blazorise.Bootstrap5;
using Blazorise.Icons.FontAwesome;

namespace GVM;
using Blazorise;
using Blazorise.Bootstrap;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System.Reflection;
using System.Resources;

public static class MauiProgram
{
	public static MauiApp CreateMauiApp()
	{
		var builder = MauiApp.CreateBuilder();
		builder
			.UseMauiApp<App>()
			.ConfigureFonts(fonts =>
			{
				fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
			});


        // Get the assembly resource manager for the current assembly
        ResourceManager rm = new ResourceManager("GVM.Properties.Resources",
            Assembly.GetExecutingAssembly());
		// Get the value of the key
		string value = rm.GetString("GVMConnectionString");

        builder.Services.AddDbContext<GVMContext>(options => options.UseSqlServer(value));


        builder.Services.AddBlazorise(options => { options.Immediate = true; }).AddBootstrapProviders();
		builder.Services.AddMauiBlazorWebView();
        builder.Services
			.AddBlazorise(options =>
			{
				options.Immediate = true;
			})
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
