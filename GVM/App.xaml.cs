using GVM.Pages;

namespace GVM;

public partial class App : Application
{
	public App()
	{
		InitializeComponent();

		MainPage = new MainPage();
	}

    protected override void OnAppLinkRequestReceived(Uri uri) {
        base.OnAppLinkRequestReceived(uri);

        // Handle the received URL
        if (uri.Scheme == "gvmapp") // Replace 'gvmapp' with your actual scheme
        {
            // Parse the URL and take appropriate action
            // For example, navigate to a specific page based on the URL path
            string path = uri.Host + uri.PathAndQuery;
            MainPage.Navigation.PushAsync(new NavigationPage(new URLNavigationPage(path)));
        }
    }
}
