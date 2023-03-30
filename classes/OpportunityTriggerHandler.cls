public class OpportunityTriggerHandler {    // NOPMD
    public static void beforeInsert(List<Opportunity> newList) {   // NOPMD(BLACKSPACE)
        changeDescription(newList);
    }
    public static void afterInsert(List<Opportunity> newList) {  // NOPMD(BLACKSPACE)
        opportunityAmountStoringHandler(newList);
    }
    public static void beforeUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {  // NOPMD(BLACKSPACE)
        opportunityStage(newList, oldMap);
        updatedToclosedLost(newList, oldMap);
    }
    public static void afterUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {   // NOPMD(BLACKSPACE)
        opportunityStageTaskReacord(newList, oldMap);
    }
    public static void beforeDelete(List<Opportunity> oldList) {   // NOPMD(BLACKSPACE)
        opportunityClosed(oldList);
    }
    public static void afterDelete(List<Opportunity> oldList) {   // NOPMD(BLACKSPACE)S
    }

    public static void changeDescription(List<Opportunity> newOpportunities) {
        for(Opportunity opportunity : newOpportunities) {
            if(opportunity.Amount != NULL && opportunity.Amount > 100000) {
                opportunity.Description = 'Hot Opportunity';

			}
        }
    }

    public static void opportunityAmountStoringHandler(List<Opportunity> opportunities) {
        List<Account> accountsUpdated = OpportunityService.opportunityRelatedAccounts(opportunities);
        for (Opportunity opportunity : opportunities) {
            if (opportunity.Amount != null && opportunity.AccountId != null) {
                Account account = new Account(Id = opportunity.AccountId);
                account.Recent_Opportunity_Amount__c = opportunity.Amount;
                accountsUpdated.add(account);
            }
        }
        if (!accountsUpdated.isEmpty()) {
            update accountsUpdated;   // NOPMD
        }
    }

    private static void opportunityStage(List<Opportunity> opportunities, Map<Id,Opportunity> opportunityMap){
        for (Opportunity opportunity : opportunities) {
            if(opportunityMap.containskey(opportunity.Id) && opportunity.StageName != opportunityMap.get(opportunity.Id).StageName){
                if(opportunity.StageName == 'Opp is Closed Lost'){
                    opportunity.Description = 'Opportunity is Closed and Lost!';
                }
                else if(opportunity.StageName == 'Opp is Closed Won'){
                    opportunity.Description = 'Opportunity is Closed and Won!';
                }
                else{
                    opportunity.Description = 'Opportunity is Open!';
                }
            }
        }
    }

    private static void opportunityStageTaskReacord(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap){
        List<Task> newTasks = new List<Task>();

        for (Integer i = 0; i < opportunities.size()-1; i++) {
            Task newTask = new Task();
            newTask.OwnerId = UserInfo.getUserId();
            newTask.status = 'The Stage';
            newTask.priority = 'High';
            newTasks.add(newTask);
        
        }
        insert newTasks;              // NOPMD
    }

    private static void updatedToClosedLost(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap){
        for(Opportunity opportunity : opportunities) {
            if((opportunity.StageName == 'Closed Lost' && opportunityMap.get(opportunity.id).StageName != 'Closed Lost' && opportunity.Closed_Lost_Reason__c == opportunityMap.get(opportunity.id).Closed_Lost_Reason__c)) {
                opportunity.Closed_Lost_Reason__c.addError('Please populate Closed Lost Reason');
            }
        }
    }

    private static void opportunityClosed(List<Opportunity> opportunities){
        Id profileId = userinfo.getProfileId();
        Id systemAdminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        for(Opportunity opportunity : opportunities) {
            if(profileId != systemAdminId ) {
                opportunity.addError('You do not have permission to delete this opportunity.');
            }
        }
    }
    
}