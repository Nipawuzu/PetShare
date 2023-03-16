using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseContextLibrary.models
{
    public class Pet
    {
        public Guid Id { get; set; }
        public Guid ShelterId { get; set; }
        public Shelter Shelter { get; set; }
        public string Name { get; set; }
        public string Species { get; set; }
        public string Breed { get; set; }
        public DateTime Birthday { get; set; }
        public string Description { get; set; }
        public byte[] Photo { get; set; }
    }
}
