using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Utils.Errors {
    public class IncorrectPasswordException : AuthenticationException {
            public IncorrectPasswordException() : base("La contraseña es incorrecta.") {
            }

            public IncorrectPasswordException(string message)
                : base(message) {
            }

            public IncorrectPasswordException(string message, Exception inner)
                : base(message, inner) {
            }
    }
}
