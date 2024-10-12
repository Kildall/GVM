using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.Response {
    public class SignupResponse : Response {
        public new SignupData data { get; set; }

        public class SignupData {
            public string message { get; set; }
        }
    }
}
