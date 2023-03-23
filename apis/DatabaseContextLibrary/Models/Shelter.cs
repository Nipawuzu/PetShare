using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseContextLibrary.models
{
    public class Shelter
    {
        public Guid Id { get; set; }
        public string UserName { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public Guid AddressId { get; set; }
        public string FullShelterName { get; set; }
        public bool IsAuthorized { get; set; } = false;
        public Address Address { get; set; }

        public bool HaveSameValues(Shelter sh)
        {
            return UserName == sh.UserName &&
                PhoneNumber == sh.PhoneNumber &&
                Email == sh.Email &&
                FullShelterName == sh.FullShelterName &&
                IsAuthorized == sh.IsAuthorized &&
                Address.HaveSameValues(sh.Address);
        }
    }
}
