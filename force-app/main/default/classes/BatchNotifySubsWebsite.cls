public class BatchNotifySubsWebsite implements Database.Batchable<SObject> {
  String operation;
  Integer daysToGo;

  public BatchNotifySubsWebsite(String operation, Integer daysToGo) {
    this.operation = operation;
    this.daysToGo = daysToGo;
  }

  public Database.QueryLocator start(Database.BatchableContext context) {
    String queryOpportunities = 'select Id, Name, createdDate, AccountID, OwnerId, (SELECT Id, Product__r.ProductCode, Product__r.Name, Original_Expiry_Date__c, Subscription_Status__c FROM Subscription_Products__r WHERE Subscription_Status__c = \'Active\') FROM Opportunity';
    String varQuery = ' WHERE CreatedDate >= 2023-08-29T15:20:02Z AND CreatedDate <= 2023-09-05T00:00:00Z';

    //if (!Test.isRunningTest()) {
    queryOpportunities += varQuery;
    //}

    return Database.getQueryLocator(queryOpportunities);
  }

  public void execute(
    Database.BatchableContext context,
    List<Opportunity> opportunities
  ) {
    List<Task> tasksToInsert = new List<Task>();
    List<Opportunity> opportunitiesToSendEmail = new List<Opportunity>();

    // List<Local_Search__c> productCodes = [select Id, Product_Codes__c FROM Local_Search__c]; // Limit query to one record
    // String productCodesString = productCodes.isEmpty() ? ''  : productCodes[0].Product_Codes__c;

    // if (!String.isBlank(productCodesString)) {
    //   List<String> websiteProductcodes = productCodesString.split(',');
    //   system.debug('websiteProductcodes ' + websiteProductcodes);

    List<string> websiteProductcodes = new List<string>();
    websiteProductcodes.add('151');
    websiteProductcodes.add('152');
    websiteProductcodes.add('153');
    websiteProductcodes.add('154');
    websiteProductcodes.add('155');
    system.debug('websiteProductcodes :' + websiteProductcodes);

    for (Opportunity opp : opportunities) {
      Boolean foundDiscountProduct = false;
      Boolean foundWebsiteProduct = false;

      for (Subscription_Product__c subProduct : opp.Subscription_Products__r) {
        Date termEndDate = subProduct.Original_Expiry_Date__c;
        String productCode = subProduct.Product__r.ProductCode;

        String OpportunityId = opp.AccountId;
        String OwnerId = opp.OwnerId;

        if (
          termEndDate != null &&
          termEndDate == Date.today().addDays(this.daysToGo) &&
          productCode == '260'
        ) {
          foundDiscountProduct = true;
          system.debug('Executed 1');
          system.debug('Executed 1 =======> ' + productCode);
        }

        if (websiteProductcodes.contains(productCode)) {
          foundWebsiteProduct = true;
          system.debug('Executed 3 =======> ' + productCode);
        }

        if (foundDiscountProduct) {
          system.debug('Executed 4');
          if (this.operation == 'createTask') {
            // Create Task
            Task task = new Task();

            task.WhoId = OpportunityId;

            task.Subject = 'TBC';
            task.Status = 'Not Started';
            task.Priority = 'High';
            task.ActivityDate = Date.today().addDays(1);
            task.OwnerId = OwnerId;
            tasksToInsert.add(task);
          }

          if (this.operation == 'sendEmail') {
            opportunitiesToSendEmail.add(opp);
          }
        }
      }
      //}
    }

    System.debug('Number of tasks to insert: ' + tasksToInsert.size());
    System.debug(
      'Number of opportunities to send email: ' +
      opportunitiesToSendEmail.size()
    );

    // Insert tasks
    if (!tasksToInsert.isEmpty()) {
      insert tasksToInsert;
    }

    // Send emails
    if (this.operation == 'sendEmail' && !opportunitiesToSendEmail.isEmpty()) {
      EmailNotifySubscription.sendEmails(opportunitiesToSendEmail);
    }
  }

  public void finish(Database.BatchableContext context) {
    System.debug('Batch Executed Successfully');
  }
}
