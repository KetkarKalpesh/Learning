public with sharing class NoteController {
    @AuraEnabled(cacheable=true)
    public static List<Note> getNotesRelatedToCases(Id caseId) {
        List<Note> notesRelatedToAccount = new List<Note>();

        List<Case> casesWithAccount = [SELECT AccountId FROM Case WHERE Id = :caseId];

        if (!casesWithAccount.isEmpty()) {
            Id accountId = casesWithAccount[0].AccountId;

            notesRelatedToAccount = [SELECT Id, Title, Body, CreatedById, CreatedBy.FirstName, CreatedBy.LastName, OwnerId , CreatedDate FROM Note WHERE ParentId =: accountId];
        }

        return notesRelatedToAccount;
    }

    @AuraEnabled(cacheable=true)
    public static String getAccountName(Id accountId) {
        Account acc = [SELECT Name FROM Account WHERE Id = :accountId LIMIT 1];
        return acc != null ? acc.Name : '';
    }
}