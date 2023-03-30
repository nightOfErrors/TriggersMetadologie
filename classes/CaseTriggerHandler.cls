public class CaseTriggerHandler {        // NOPMD
    public static void beforeInsert(List<Case> newList) {  // NOPMD(BLACKSPACE)
    }
    public static void afterInsert(List<Case> newList) {  // NOPMD(BLACKSPACE)
        storingLatestCase(newList);
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
}