using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.Request {
    public class SignupRequest {
        public string email {  get; set; }
        public string password { get; set; }
        public string name { get; set; }

        public SignupRequest(string email, string password, string name) {
            this.email = email;
            this.password = password;
            this.name = name;
        }
    }
}
