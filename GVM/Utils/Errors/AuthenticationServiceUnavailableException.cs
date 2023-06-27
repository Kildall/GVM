using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Utils.Errors {
    public class AuthenticationServiceUnavailableException : AuthenticationException {
        public AuthenticationServiceUnavailableException() : base("El servicio de autenticacion no esta disponible.") {
        }

        public AuthenticationServiceUnavailableException(string message)
            : base(message) {
        }

        public AuthenticationServiceUnavailableException(string message, Exception inner)
            : base(message, inner) {
        }
    }
}
