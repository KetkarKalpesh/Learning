public class EmailNotifySubscription {
  /*
   * @description - Method use to Send Email Notification regarding 'Website Subscription Offer' is Expiring
   * @param - List of Opportunities
   * @return - Email Service to the Batch Class
   */
  public static List<Messaging.SingleEmailMessage> sendEmails(
    List<Opportunity> opportunities
  ) {
    List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();

    //     // Billing_Email__c, Business_Email__c
    for (Opportunity opp : opportunities) {
      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

      List<String> emailAddresses = new List<String>();
      emailAddresses.add('kkofficial1001@gmail.com');

      //         email.setBccAddresses(
      //           new List<String>{ opp.Account.Business_Email__c }
      //         );

      //         string templateName = 'Website Subscription Offer End Notification';
      //         id emailTemplateId = getEmailTemplateId(templateName);

      //         string displayName = 'Enquiries';
      //         string orgWideDefEmail = getOwdEmailId(displayName);*/

      //         //if (emailTemplateId != null && orgWideDefEmail != null) {
      //           email.setTemplateId(emailTemplateId);
      email.setPlainTextBody(
        'Offer is Expiring soon! We are providing you a discount on your previous Products.'
      );
      email.setSubject('Subscription Website Free Upgrade Offer');
      email.setToAddresses(emailAddresses);
      //           email.setOrgWideEmailAddressId(orgWideDefEmail);
      emailMessages.add(email);
      //         //}
      //       }
    }
    return emailMessages;
  }

  //   /*
  //    * @description - Method use to send prepared email messages
  //    * @param - List of Messaging.SingleEmailMessage
  //    * @return - Result, Weather Email get sent successfully or not
  //    */
  //   public static void sendEmails(
  //     List<Messaging.SingleEmailMessage> emailMessages
  //   ) {
  //     if (!emailMessages.isEmpty()) {
  //       List<Messaging.SendEmailResult> sendResults = Messaging.sendEmail(
  //         emailMessages
  //       );

  //       for (Messaging.SendEmailResult result : sendResults) {
  //         if (result.isSuccess()) {
  //           System.debug('Email sent successfully.');
  //         } else {
  //           System.debug(
  //             'Email sending failed: ' + result.getErrors()[0].getMessage()
  //           );
  //         }
  //       }
  //     }
  //   }

  //   /*
  //    * @description - Method use to retrieve the Id of an Email Template by its name
  //    * @param - Email Template Name
  //    * @return - Id of the Email Template, or null if not found
  //    */
  //   public static Id getEmailTemplateId(String templateName) {
  //     List<EmailTemplate> emailTemplates = [
  //       SELECT Id
  //       FROM EmailTemplate
  //       WHERE Name = :templateName
  //       LIMIT 1
  //     ];

  //     return (emailTemplates.isEmpty()) ? null : emailTemplates[0].Id;
  //   }

  //   /*
  //    * @description - Method use to retrieve the Org Wide Email Address
  //    * @param - Org Wide Email Display Name
  //    * @return - Org Wide Email, or null if not found
  //    */
  //   public static Id getOwdEmailId(String displayName) {
  //     List<OrgWideEmailAddress> orgWideDefaultEmail = [
  //       SELECT Id, Address, DisplayName
  //       FROM OrgWideEmailAddress
  //       WHERE DisplayName = :displayName
  //       LIMIT 1
  //     ];

  //     return (orgWideDefaultEmail.isEmpty()) ? null : orgWideDefaultEmail[0].Id;
  //   }
}
