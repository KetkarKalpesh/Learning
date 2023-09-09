public class EmailNotifySubscription {
  /*
   * @description - Method used to Send Email Notification regarding 'Website Subscription Offer' is Expiring
   * @param - List of Opportunities
   * @return - Email Service to the Batch Class
   */
  public static void sendEmails(List<Opportunity> opportunities) {
    List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();

    for (Opportunity opp : opportunities) {
      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

      List<String> emailAddresses = new List<String>();
      emailAddresses.add(UserInfo.getUserEmail());

      // Corrected SOQL query
      EmailTemplate emailTemplate = [
        SELECT Id, DeveloperName
        FROM EmailTemplate
        WHERE DeveloperName = 'Subscription_Offer_Expiring_1694256071469'
      ];

      email.setPlainTextBody(
        'Offer is Expiring soon! We are providing you a discount on your previous Products.'
      );
      email.setSubject('Subscription Website Free Upgrade Offer');
      email.setToAddresses(emailAddresses);
      email.setTemplateId(emailTemplate.Id);
      emailMessages.add(email);
    }

    if (!emailMessages.isEmpty()) {
      Messaging.sendEmail(emailMessages);
    }
  }
}
