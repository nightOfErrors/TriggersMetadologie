public with sharing class ContactTriggerHandler {

    public static void beforeInsert(List<Contact> newList) {          //NOPMD
        emailUponCreation(newList);
    }

    public static void afterInsert(List<Contact> newList) {     //NOPMD
    }

    public static void beforeUpdate(List<Contact> newList, Map<Id, Contact> oldMap) { //NOPMD
    }

    public static void afterUpdate(List<Contact> newList, Map<Id, Contact> oldMap) { //NOPMD
    }

    public static void beforeDelete(List<Contact> oldList) { //NOPMD
    }

    public static void afterDelete(List<Contact> oldList) { //NOPMD
   
    }

    public static void afterUndelete(List<Contact> newList){  //NOPMD

    }

    public static void emailUponCreation(List<Contact> newContacts){       //21
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for (Contact contact : newContacts) {
            if (contact.Email != null && contact.Email != '') {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>{contact.Email});
                emailList.add(email);
            }
        }
        if (!emailList.isEmpty()) {
            Messaging.sendEmail(emailList);
        }
    }

}