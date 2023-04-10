using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseContextLibrary.models
{
    public class Address
    {
        public Guid Id { get; set; }
        public string Street { get; set; }
        public string City { get; set; }
        public string Province { get; set; }
        public string PostalCode { get; set; }
        public string Country { get; set; }
    }
}
