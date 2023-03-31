public class StoringLatestCaseHelper {        // NOPMD

    public static void beforeInsert(List<Account> newList) {  // NOPMD(BLACKSPACE)

    }
    
    public static void afterInsert(List<Case> newList) {  // NOPMD(BLACKSPACE)
        storingLatestCase(newList);
    }
    
    public static void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap) {   // NOPMD(BLACKSPACE)

    }
    
    public static void afterUpdate(List<Account> newList, Map<Id, Account> oldMap) {   // NOPMD(BLACKSPACE)

    }
    
    public static void beforeDelete(List<Account> oldList) {   // NOPMD(BLACKSPACE)

    }
    
    public static void afterDelete(List<Account> oldList) {   // NOPMD(BLACKSPACE)

    }

    public static void storingLatestCase(List<Case> cases) {  // NOPMD(BLACKSPACE)

        List<Account> accounts = new List<Account>();
        for(Case newCase : cases){
            if(newCase.AccountId != NULL){
                Account account = new Account();
                account.Id = newCase.AccountId;
                account.Latest_Case_Number__c = Integer.valueOf(newCase.CaseNumber);
                accounts.add(account);
            }
        }
        if(accounts != NULL){
            update accounts;        // NOPMD
        }
    }
}