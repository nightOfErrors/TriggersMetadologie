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

    public static List<Account> updateOpportunityRelatedAccounts(Set<Id> AccountIds) {      // NOPMD     //Q23   
        List<Account> accounts = new List<Account>();
        AggregateResult[] groupedResults = [SELECT AccountId, Sum(Amount)annulRevenue FROM Opportunity  WHERE AccountId IN: AccountIds GROUP BY AccountId];     // NOPMD

        for (AggregateResult variable : groupedResults) {
            String accountId = String.valueOf(variable.get('AccountId'));
            Integer annualRevenue = Integer.valueOf(variable.get('annulRevenue'));
            accounts.add(new Account(Id = accountId, AnnualRevenue = annualRevenue));
        }

        return accounts;
    }

}