using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EmailLibrary
{
    public class ApplicationStatusChangedEmailSender : EmailSender
    {
        private const string ACCEPTANCE_SUBJECT = "Zwierzak jest już Twój!";
        private const string ACCEPTANCE_MESSAGE = "Gratulacje, {0} już wkrótce zamieszka w Twoim domu! Dokończ proces adopcji przez aplikację PetShare!\nPozdrawiamy\nZespół PetShare";
        private const string REJECTION_SUBJECT = "Niestety nie tym razem :(";
        private const string REJECTION_MESSAGE = "Niestety, Twój wniosek został odrzucony. {0} nie zamieszka z Tobą, ale wiele innych zwierzaków wciąż poszukuje domu. Sprawdź teraz w aplikacji PetShare!\nPozdrawiamy\nZespół PetShare";

        public ApplicationStatusChangedEmailSender(IConfiguration configuration) : base(configuration)
        {
        }

        public async Task SendAcceptanceEmail(string? emailTo, string petName)
        {
            if (emailTo is null)
                return;
            await SendEmailAsync(emailTo, ACCEPTANCE_SUBJECT, string.Format(ACCEPTANCE_MESSAGE, petName));
        }

        public async Task SendRejectionEmail(string? emailTo, string petName)
        {
            if (emailTo is null)
                return;
            await SendEmailAsync(emailTo, REJECTION_SUBJECT, string.Format(REJECTION_MESSAGE, petName));
        }
    }
}
