public class EmailNotifySubscription {
  /*
   * @description - Method used to Send Email Notification regarding 'Website Subscription Offer' is Expiring
   * @param - List of Opportunities
   * @return - Email Service to the Batch Class
   */
  public static void sendEmail(List<Opportunity> opportunities) {
    list<Messaging.SingleEmailMessage> emailObjs = new List<Messaging.SingleEmailMessage>();
    Messaging.SingleEmailMessage emailObj = new Messaging.SingleEmailMessage();

    for (Opportunity opp : opportunities) {
      List<String> emailAddresses = new List<String>();
      emailAddresses.add('kkofficial1001@gmail.com');

      // Corrected SOQL query
      EmailTemplate emailTemplate = [
        SELECT Id, DeveloperName
        FROM EmailTemplate
        WHERE DeveloperName = 'Subscription_Offer_Expiring_1694256071469'
      ];

      emailObj.setToAddresses(emailAddresses);
      emailObj.setTemplateId(emailTemplate.Id);
      emailObj.setTargetObjectId(opp.Id);
      emailObj.setSaveAsActivity(false);
      emailObj.setSubject('Subscription Website Free Upgrade Offer');
      emailObjs.add(emailObj);

      if (!emailObjs.isEmpty()) {
        Messaging.sendEmail(emailObjs);
      }
    }
  }
}
