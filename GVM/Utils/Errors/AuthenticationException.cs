using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Utils.Errors {
    public abstract class AuthenticationException : Exception {
        protected AuthenticationException() {
        }

        protected AuthenticationException(string message)
            : base(message) {
        }

        protected AuthenticationException(string message, Exception inner)
            : base(message, inner) {
        }
    }
}
