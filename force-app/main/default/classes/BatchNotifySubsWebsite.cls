public class BatchNotifySubsWebsite implements Database.Batchable<SObject> {
  String operation;
  Integer daysToGo;

  public BatchNotifySubsWebsite(String operation, Integer daysToGo) {
    this.operation = operation;
    this.daysToGo = daysToGo;
  }

  public Database.QueryLocator start(Database.BatchableContext context) {
    String queryOpportunities = 'select Id, Name, createdDate, AccountID, Account.OwnerId, OwnerId, (SELECT Id, Product__r.ProductCode, Product__r.Name, Original_Expiry_Date__c, Subscription_Status__c FROM Subscription_Products__r WHERE Subscription_Status__c = \'Active\') FROM Opportunity';
    String varQuery = ' WHERE CreatedDate >= 2023-08-29T15:20:02Z AND CreatedDate <= 2023-09-10T00:00:00Z';

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

    LocalSearch__mdt metadataRecs = [
      SELECT Product_Codes__c
      FROM LocalSearch__mdt
      LIMIT 1
    ]; // Limit query to one record

    List<String> ProductCodes = new List<String>();

    if (!String.isBlank(metadataRecs.Product_Codes__c)) {
      ProductCodes = metadataRecs.Product_Codes__c.split(',');
      system.debug('ProductCodes ' + ProductCodes);
    }

    for (Opportunity opp : opportunities) {
      Boolean foundDiscountProduct = false;
      Boolean foundWebsiteProduct = false;
      String opportunityId = opp.AccountId;
      String ownerId = opp.Account.OwnerId;

      for (Subscription_Product__c subProduct : opp.Subscription_Products__r) {
        Date termEndDate = subProduct.Original_Expiry_Date__c;
        String productCode = subProduct.Product__r.ProductCode;

        if (productCode == '260') {
          foundDiscountProduct = true;
          if (foundWebsiteProduct) {
            break;
          }
        }

        if (
          !ProductCodes.isEmpty() &&
          ProductCodes.contains(productCode) &&
          termEndDate != null &&
          termEndDate == Date.today().addDays(daysToGo)
        ) {
          foundWebsiteProduct = true;
          if (foundDiscountProduct) {
            break;
          }
        }
      }
      if (foundDiscountProduct && foundDiscountProduct) {
        if (this.operation == 'createTask') {
          // Create Task
          Task task = new Task();

          task.WhatId = opportunityId;

          task.Subject = 'Website Subscription Offer Ending Soon!';
          task.Status = 'Not Started';
          task.Priority = 'High';
          task.ActivityDate = Date.today().addDays(1);
          task.OwnerId = Opp.OwnerId;
          tasksToInsert.add(task);
        }

        if (this.operation == 'sendEmail') {
          opportunitiesToSendEmail.add(opp);
        }
      }
    }

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
