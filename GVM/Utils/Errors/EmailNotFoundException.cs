using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Utils.Errors {
    public class EmailNotFoundException : AuthenticationException {
        public EmailNotFoundException() : base("El email no fue encontrado."){
        }

        public EmailNotFoundException(string email)
            : base($"Email: {email} no encontrado.") {
        }

        public EmailNotFoundException(string message, Exception inner)
            : base(message, inner) {
        }
    }
}
