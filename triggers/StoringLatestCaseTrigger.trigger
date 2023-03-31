trigger StoringLatestCaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete) {  // NOPMD

    switch on Trigger.operationType {
        
        when BEFORE_INSERT {
            
        }
        
        when AFTER_INSERT {
            StoringLatestCaseHelper.afterInsert(Trigger.new);
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