public with sharing class CaseService {
    public static List<Account> caseRelatedAccounts(List<Case> cases) {
        List<Account> accounts = new List<Account>();
        for(Case newCase : cases){
            if(newCase.AccountId != NULL){
                Account account = new Account();
                account.Id = newCase.AccountId;
                account.Latest_Case_Number__c = Integer.valueOf(newCase.CaseNumber);
                accounts.add(account);
            }
        }
        return accounts;
    }
}