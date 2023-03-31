public class CaseTriggerHandler {        // NOPMD
    public static void beforeInsert(List<Case> newList) {  // NOPMD(BLACKSPACE)
    }
    public static void afterInsert(List<Case> newList) {  // NOPMD(BLACKSPACE)
        storingLatestCase(newList);
        populateNumberOfCaseOnAccount(newList);
    }
    public static void beforeUpdate(List<Case> newList, Map<Id, Case> oldMap) {   // NOPMD(BLACKSPACE)
    }
    public static void afterUpdate(List<Case> newList, Map<Id, Case> oldMap) {   // NOPMD(BLACKSPACE)
    }
    public static void beforeDelete(List<Case> oldList) {   // NOPMD(BLACKSPACE)
    }
    public static void afterDelete(List<Case> oldList) {   // NOPMD(BLACKSPACE)
    }
    public static void storingLatestCase(List<Case> cases) {  // NOPMD(BLACKSPACE)
        List<Account> accounts = CaseService.caseRelatedAccounts(cases);
        if(accounts != NULL){
            update accounts;        // NOPMD
        }
    }

    private static void populateNumberOfCaseOnAccount(List<Case> cases) {                     //Q22
        RecordType partnerRecordId = [Select ID,Name from RecordType where Name = 'Partner Case'];          // NOPMD
        RecordType customerRecordId = [Select ID,Name from RecordType where Name = 'Customer Case'];          // NOPMD
        Map<Id, Account> accountMap = new Map<Id, Account>();
        Set<Id> partnerAccountIds = new Set<Id>();
        Set<Id> customerAccountIds = new Set<Id>();
        for (Case c : cases) {
            if (partnerRecordId.Id == c.RecordTypeId) {
                partnerAccountIds.add(c.AccountId);
            } else if (customerRecordId.Id == c.RecordTypeId) {
                customerAccountIds.add(c.AccountId);
            }
        }
        List<Account> partnerAccountsToUpdate = [SELECT Id, Total_Partner_Cases__c FROM Account WHERE Id IN :partnerAccountIds];          // NOPMD
        for (Account account : partnerAccountsToUpdate) {
            if(account.Total_Partner_Cases__c == null) {
                account.Total_Partner_Cases__c = 1;
            }
            else {
                account.Total_Partner_Cases__c = account.Total_Partner_Cases__c + 1;
            }
            accountMap.put(account.Id, account);
        }
        List<Account> customerAccountsToUpdate = [SELECT Id, Total_Partner_Cases__c FROM Account WHERE Id IN :customerAccountIds];  // NOPMD
        for (Account account : customerAccountsToUpdate) {
            if(account.Total_Partner_Cases__c == null) {
                account.Total_Partner_Cases__c = 1;
            }
            else {
                account.Total_Partner_Cases__c = account.Total_Partner_Cases__c + 1;
            }
            accountMap.put(account.Id, account);
        }
        
        update accountMap.values();
    } 

}