public with sharing class UserTriggerHandler {

    public static void beforeInsert(List<User> newList) {          // NOPMD  
    }
    
    public static void afterInsert(List<User> newList) {
        addAdminToPublicGroup(newList);
    }
    
    public static void beforeUpdate(List<User> newList, Map<Id, User> oldMap) {         // NOPMD  
        
    }
    
    public static void afterUpdate(List<User> newList, Map<Id, User> oldMap) {
        updateAdminToPublicGroup(newList, oldMap);
    }
    
    public static void beforeDelete(List<User> oldList) {             // NOPMD  
        
    }
    
    public static void afterDelete(List<User> oldList) {      // NOPMD  
        
    }

    private static void addAdminToPublicGroup(List<User> users) {                       //Q29
        Id IdOfGroup = [SELECT Id FROM Group WHERE Name ='Admins' LIMIT 1].Id;                   // NOPMD  
        Id adminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        List<GroupMember> groupMembers = new List<GroupMember>();

        for (User user : users) {
            if (user.ProfileId == adminProfileId && user.IsActive == true) {
                groupMembers.add(new GroupMember(GroupId = IdOfGroup, UserOrGroupId = user.Id));
            }
        }
        if (!groupMembers.isEmpty()) {
            insert groupMembers;                            // NOPMD  
        }
    }

    private static void updateAdminToPublicGroup(List<User> users, Map<Id, User> userMap) {            //Q29 CONTINUATION
        Id IdOfGroup = [SELECT Id FROM Group WHERE Name ='Admins' LIMIT 1].Id;                                    // NOPMD  
        Id adminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        List<GroupMember> groupMembers = new List<GroupMember>();

        for (User user : users) {
            if ((user.ProfileId != userMap.get(user.Id).ProfileId 
                 || user.IsActive != userMap.get(user.Id).IsActive) 
                 && user.ProfileId == adminProfileId 
                 && user.IsActive == true) {
                groupMembers.add(new GroupMember(GroupId = IdOfGroup, UserOrGroupId = user.Id));
            }
        }
        if (!groupMembers.isEmpty()) {
            insert groupMembers;                           // NOPMD  
        }
    }

}
