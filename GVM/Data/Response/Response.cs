using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GVM.Data.Response {
    public abstract class Response {
        public ResponseStatus status { get; set; }
        public object data { get; set; }

        public class ResponseStatus {
            public bool success { get; set; }
            public object[] errors { get; set; }
        }
    }
}
