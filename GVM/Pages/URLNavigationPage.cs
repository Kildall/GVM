using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Pages {
    public class URLNavigationPage : ContentPage {
        public URLNavigationPage(string path) {
            // Handle the specific path and set up your page accordingly
            Content = new StackLayout {
                Children = {
                new Label { Text = $"Navigated to: {path}" }
            }
            };
        }
    }
}
