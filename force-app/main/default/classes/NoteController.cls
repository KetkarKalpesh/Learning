public with sharing class NoteController {
  @AuraEnabled(cacheable=true)
  public static List<Note> getNotesRelatedToCases(Id caseId) {
    List<Note> notesRelatedToAccount = new List<Note>();

    List<Case> casesWithAccount = [
      SELECT AccountId
      FROM Case
      WHERE Id = :caseId
      LIMIT 1
    ];

    if (!casesWithAccount.isEmpty()) {
      Id accountId = casesWithAccount[0].AccountId;

      List<Note> accNotes = [
        SELECT
          Id,
          Title,
          Body,
          CreatedById,
          CreatedBy.FirstName,
          CreatedBy.LastName,
          OwnerId,
          CreatedDate
        FROM Note
        WHERE ParentId = :accountId
      ];

      notesRelatedToAccount.addAll(accNotes);
    }

    List<Opportunity> oppCases = [
      SELECT Id, Case__c, Lead__c
      FROM Opportunity
      WHERE Case__c = :caseId AND Lead__c = :caseId
      LIMIT 1
    ];

    if (!oppCases.isEmpty()) {
      Id oppId = oppCases[0].Id;
      Id leadId = oppCases[0].Lead__c;

      if (oppId != null) {
        List<Note> oppNotes = [
          SELECT
            Id,
            Title,
            Body,
            CreatedById,
            CreatedBy.FirstName,
            CreatedBy.LastName,
            OwnerId,
            CreatedDate
          FROM Note
          WHERE ParentId = :oppId
        ];
        notesRelatedToAccount.addAll(oppNotes);
      }

      if (leadId != null) {
        List<Note> leadNotes = [
          SELECT
            Id,
            Title,
            Body,
            CreatedById,
            CreatedBy.FirstName,
            CreatedBy.LastName,
            OwnerId,
            CreatedDate
          FROM Note
          WHERE ParentId = :leadId
        ];
        notesRelatedToAccount.addAll(leadNotes);
      }
    }

    return notesRelatedToAccount;
  }

  @AuraEnabled(cacheable=true)
  public static String getAccountName(Id accountId) {
    Account acc = [SELECT Name FROM Account WHERE Id = :accountId LIMIT 1];
    return acc != null ? acc.Name : '';
  }
}
