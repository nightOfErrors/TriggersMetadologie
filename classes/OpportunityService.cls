public with sharing class OpportunityService {
    public static List<Account> opportunityRelatedAccounts(List<Opportunity> opportunities) {
        List<Account> accountsUpdated = new List<Account>();
        for (Opportunity opportunity : opportunities) {
            if (opportunity.Amount != null && opportunity.AccountId != null) {
                Account account = new Account(Id = opportunity.AccountId);
                account.Recent_Opportunity_Amount__c = opportunity.Amount;
                accountsUpdated.add(account);
            }
        }
        return accountsUpdated;
    }
}