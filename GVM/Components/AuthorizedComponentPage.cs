using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GVM.Data;
using GVM.Services;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Routing;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

namespace GVM.Components {
    public class AuthorizedComponentPage : ComponentBase, IDisposable {

        [Inject]
        public SeguridadService SeguridadService { get; set; }

        [Inject]
        public NavigationManager NavigationManager { get; set; }

        [Inject]
        public GVMContext GVMContext { get; set; }

        private IDisposable? registration;

        protected override void OnAfterRender(bool firstRender) {
            if (firstRender) {
                registration =
                    NavigationManager.RegisterLocationChangingHandler(OnLocationChanging);
            }
        }

        private ValueTask OnLocationChanging(LocationChangingContext context) {
            if (!SeguridadService.ValidarPermiso(GetFirstRouteSegment(context.TargetLocation))) {
                context.PreventNavigation();
            }

            if (!SeguridadService.EstaLogeado) {
                NavigationManager.NavigateTo("/login");
            }

            return ValueTask.CompletedTask;
        }

        private string GetFirstRouteSegment(string url) {
            string[] segments;

            if (Uri.IsWellFormedUriString(url, UriKind.Absolute)) {
                Uri uri = new Uri(url);
                segments = uri.AbsolutePath.Split('/');
            } else if (Uri.IsWellFormedUriString(url, UriKind.Relative)) {
                segments = url.Split('/');
            } else {
                throw new UriFormatException("The provided URL is not a valid absolute or relative URL.");
            }

            return segments.Length > 1 ? "/" + segments[1] : null;
        }

        public void Dispose() => registration?.Dispose();
    }
}
