public class PositionTriggerHandler {

    public static void beforeInsert(List<Position__c> newList) {  // NOPMD(BLACKSPACE)
        creationOfPosition(newList);
    }
    
    public static void afterInsert(List<Position__c> newList) {  // NOPMD(BLACKSPACE)
        
    }
    
    public static void beforeUpdate(List<Position__c> newList, Map<Id, Position__c> oldMap) {  // NOPMD(BLACKSPACE)

    }
    
    public static void afterUpdate(List<Position__c> newList, Map<Id, Position__c> oldMap) {   // NOPMD(BLACKSPACE)

    }
    
    public static void beforeDelete(List<Position__c> oldList) {  // NOPMD(BLACKSPACE)

    }
    
    public static void afterDelete(List<Position__c> oldList) {   // NOPMD(BLACKSPACE)

    }

    public static void creationOfPosition(List<Position__c> positions) {
        for (position__c position : positions) {
            if((position.Open_Date__c == NULL) && (position.Min_Pay__c == NULL) && (position.Max_Pay__c == NULL)){
                position.Open_Date__c = System.today();
                position.Min_Pay__c = 10000;
                position.Max_Pay__c = 15000;
            }
        }
    }
}