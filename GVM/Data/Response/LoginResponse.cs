using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.Response {
    public class LoginResponse : Response {
        public new LoginData data { get; set; }

        public class LoginData {
            public DateTime expires { get; set; }
            public string token { get; set; }
            public bool verified { get; set; }
        }
    }
}
