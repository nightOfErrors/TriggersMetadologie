trigger PositionTrigger on Position__c (before insert, before update, before delete, after insert, after update, after delete) { // NOPMD

    switch on Trigger.operationType {
        
        when BEFORE_INSERT {
            PositionTriggerHandler.beforeInsert(Trigger.new);
        }
        
        when AFTER_INSERT {
            
        }
        
        when BEFORE_UPDATE {
            
        }
        
        when AFTER_UPDATE {
            
        }
        
        when BEFORE_DELETE {
          
        }
        
        when AFTER_DELETE {
            
        }
        
    }

}