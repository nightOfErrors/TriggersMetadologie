public with sharing class AccountTriggerHandler {
    public static void beforeInsert(List<Account> newList) {
        updateRatingRelatedToIndustry(newList);
        copyBillingToShippingAddress(newList);
    }

    public static void afterInsert(List<Account> newList) {
        createRelatedContact(newList);
        createRelatedRecordBasedOnChoice(newList);
        createRelatedOpportunity(newList);
    }

    public static void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap) { //NOPMD
        populateDescription(newList, oldMap);
        updateRatingRelatedToIndustry(newList);
        preventAccountRecordEdit(newList, oldMap);
    }

    public static void afterUpdate(List<Account> newList, Map<Id, Account> oldMap) { //NOPMD
        accountPhoneUpdate(newList, oldMap);
        updatingContactMailingAddress(newList, oldMap);
        accountPhoneUpdateLoop(newList, oldMap);
        copyBillingToShippingAddressWithQuery(newList, oldMap);
        accountActivefieldIsUpdated(newList, oldMap);
    }

    public static void beforeDelete(List<Account> oldList) { //NOPMD
        accountRecordsDelete(oldList);
        accountCheckSystemAdministrator(oldList);
    }

    public static void afterDelete(List<Account> oldList) { //NOPMD
        restrictDeletionIfOpportunity(oldList);
        restrictAccountDeleteIfCase(oldList);
    }

    private static void updateRatingRelatedToIndustry(List<Account> accounts) {
        for(Account account: accounts ){
            if(account.Industry != NULL && account.Industry == 'Media') {
                account.Rating = 'Hot';
            }
        }
    }
    
    private static void copyBillingToShippingAddress(List<Account> accounts) { //NOPMD
        for(Account account : accounts) {
            if(account.CopyBillingToShipping__c) {
                if(account.BillingStreet != NULL) account.ShippingStreet = account.BillingStreet;   //NOPMD
                if(account.BillingCity != NULL) account.ShippingCity = account.BillingCity;     //NOPMD
                if(account.BillingPostalCode != NULL) account.ShippingPostalCode = account.BillingPostalCode;   //NOPMD
                if(account.BillingState != NULL) account.ShippingState = account.BillingState;  //NOPMD
                if(account.BillingCountry != NULL) account.ShippingCountry =  account.BillingCountry;   //NOPMD
            }
        }
    }

    private static void createRelatedContact(List<Account> accounts) {
        List<Contact> contacts = AccountService.accountRelatedContacts(accounts);
        if(!contacts.isEmpty()) {
            insert contacts;        //NOPMD
        }
    }

    private static void createRelatedRecordBasedOnChoice(List<Account> accounts) {
        for(Account account : accounts) {
            if(account.Contact__c){
                List<Contact> contacts = AccountService.createContact(accounts);
                if(!contacts.isEmpty()) {
                    insert contacts;          //NOPMD
                }
            }
            if(account.Opportunity__c && account.Active__c == 'Yes'){
                List<Opportunity> opportunities = AccountService.createOpportunity(accounts);
                if(!opportunities.isEmpty()) {
                    insert opportunities;        //NOPMD
                }
            }
        }
    }

    private static void createRelatedOpportunity(List<Account> accounts) {
        for(Account account : accounts) {
            List<Opportunity> opportunities = AccountService.createOpportunity(accounts);
            if(!opportunities.isEmpty()) {
                insert opportunities;         //NOPMD
            }
        }
    }

    private static void populateDescription(List<Account> accounts, Map<Id,Account> accountMap) {
        for(Account account : accounts) {
            if(account.Phone != accountMap.get(account.Id).Phone) {
                account.Description = 'Phone Updated. Old Value is : ' + accountMap.get(account.Id).Phone + ' & New Value : ' + account.Phone;
            }
        }
    }

    private static void accountPhoneUpdate(List<Account> accounts, Map<Id, Account> accountMap){
        Map<Id, Account> newAccountMap = new Map<Id, Account>(accounts);
        List<Contact> contacts = [SELECT Id, HomePhone, AccountId FROM Contact WHERE AccountId IN:newAccountMap.keySet()];   //NOPMD
        for (Contact contact : contacts) {
            if(accountMap.get(contact.Id) != newAccountMap.get(contact.AccountId)){
                contact.HomePhone = newAccountMap.get(contact.Id).Phone;
            }
        }
        update contacts;   //NOPMD
    }

    private static void accountPhoneUpdateLoop(List<Account> accounts, Map<Id, Account> accountMap){
        List<Account> accountsWithContacts = [SELECT Id, Phone, (SELECT Id, HomePhone FROM Contacts) FROM Account WHERE Id IN:accountMap.keySet()];         //NOPMD
        
        for (Account account : accountsWithContacts) {
            for (Contact contact : account.contacts) {
                Account oldAccount = accountMap.get(account.Id);
                contact.HomePhone = account.Phone;
            }
        }
        update accountsWithContacts;   //NOPMD
    }
    

    public static void updatingContactMailingAddress(List<Account> accounts, Map<Id, Account> accountMap){ //NOPMD
        Map<Id, Account> newAccountMap = new Map<Id, Account>(accounts);
        List<Contact> contacts = [SELECT Id, AccountId, HomePhone, MailingCity, MailingCountry, MailingGeocodeAccuracy, MailingLatitude, MailingPostalCode, MailingState, MailingStreet FROM Contact WHERE AccountId IN:newAccountMap.keySet()];   //NOPMD
        
        for (Contact contact : contacts) {
            Account account = accountMap.get(contact.AccountId);
            Account newAccount = newAccountMap.get(contact.AccountId);

            if(newAccount.Phone != account.Phone){
                contact.HomePhone = newAccount.Phone;
            }

            if(newAccount.BillingCity != NULL && newAccount.BillingCity != account.BillingCity) { 
                contact.MailingCity = newAccount.BillingCity;
            }

            if(newAccount.BillingCountry != NULL && newAccount.BillingCountry != account.BillingCountry) { 
                contact.MailingCountry = newAccount.BillingCountry;
            }

            if(newAccount.BillingGeocodeAccuracy != NULL && newAccount.BillingGeocodeAccuracy != account.BillingGeocodeAccuracy) { 
                contact.MailingGeocodeAccuracy = newAccount.BillingGeocodeAccuracy;
            }

            if(newAccount.BillingLatitude != NULL && newAccount.BillingAddress != account.BillingAddress) { 
                contact.MailingLatitude = newAccount.BillingLatitude;
            }

            if(newAccount.BillingPostalCode != NULL && newAccount.BillingPostalCode != account.BillingPostalCode) { 
                contact.MailingPostalCode = newAccount.BillingPostalCode;
            }

            if(newAccount.BillingState != NULL && newAccount.BillingState != account.BillingState) { 
                contact.MailingState = newAccount.BillingState;
            }

            if(newAccount.BillingStreet != NULL && newAccount.BillingStreet != account.BillingStreet) { 
                contact.MailingStreet = newAccount.BillingStreet;
            }
        }
        update contacts;   //NOPMD
    }
    
    private static void copyBillingToShippingAddressWithQuery(List<Account> accounts, Map<Id, Account> accountMap){        //NOPMD
        List<Account> AccountsWithContacts = [SELECT Id, BillingStreet, BillingState, BillingPostalCode, BillingAddress, BillingGeocodeAccuracy, BillingCountry, BillingCity, BillingLatitude, ( SELECT Id, AccountId, MailingCity, MailingCountry, MailingGeocodeAccuracy, MailingLatitude, MailingPostalCode, MailingState, MailingStreet FROM Contacts ) FROM Account WHERE Id IN: accountMap.keySet()];     //NOPMD
        List<Contact> contacts = new List<Contact>();

        for (Account account : AccountsWithContacts) {
            Account oldAccount = accountMap.get(account.Id);

            for (Contact contact : account.contacts) {

                if(account.BillingCity != NULL && account.BillingCity != oldAccount.BillingCity) { 
                    contact.MailingCity = account.BillingCity;
                }

                if(account.BillingCountry != NULL && account.BillingCountry != oldAccount.BillingCountry) { 
                    contact.MailingCountry = account.BillingCountry;
                }

                if(account.BillingGeocodeAccuracy != NULL && account.BillingGeocodeAccuracy != oldAccount.BillingGeocodeAccuracy) { 
                    contact.MailingGeocodeAccuracy = account.BillingGeocodeAccuracy;
                }

                if(account.BillingLatitude != NULL && account.BillingAddress != oldAccount.BillingAddress) { 
                    contact.MailingLatitude = account.BillingLatitude;
                }

                if(account.BillingPostalCode != NULL && account.BillingPostalCode != oldAccount.BillingPostalCode) { 
                    contact.MailingPostalCode = account.BillingPostalCode;
                }
                
                if(account.BillingState != NULL && account.BillingState != oldAccount.BillingState) { 
                    contact.MailingState = account.BillingState;
                }
                
                if(account.BillingStreet != NULL && account.BillingStreet != oldAccount.BillingStreet) { 
                    contact.MailingStreet = account.BillingStreet;
                }
                contacts.add(contact);
            } 
        }
        update contacts;         //NOPMD
    }
    
    private static void accountActivefieldIsUpdated(List<Account> accounts, Map<Id, Account> accountMap){

        List<Account> approvedAccounts = new List<Account>();
        Map<Id, Account> approvedAccountsMap = new Map<Id, Account>(approvedAccounts);

        for (Account account : accounts) {
            if((account.Active__c == 'No') && (accountMap.get(account.Id).Active__c == 'Yes')){
                approvedAccounts.add(account);
            }
        }

        List<Opportunity> opportunities = [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN:accountMap.keySet()];   //NOPMD
        for (Opportunity opportunity : opportunities) {
            if(opportunity.StageName != 'close won'){
                opportunity.StageName = 'close lost';
            }
        }
        update opportunities;     //NOPMD
    }

    public static void accountRecordsDelete(List<Account> oldAccounts){
        for (Account  oldAccount :  oldAccounts) {
            if( oldAccount.Active__c == 'Yes'){
                oldAccount.addError('Sorry Try To Delete Something Else.');
            }
        }
    }

    public static void preventAccountRecordEdit(List<Account> accounts, Map<Id, Account> accountMap){

        for (Account account : accounts) {
            if((account.CreatedDate > System.today().addDays(-7)) ){
                account.addError('Sorry Can Not Be Edited Before 7 Days.');
            }
        }

    }

    private static void accountCheckSystemAdministrator(List<Account> accounts){
        Id profileId = userinfo.getProfileId();
        Id systemAdminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        for(Account account : accounts) {
            if(profileId != systemAdminId ) {
                account.addError('You Does not have permission to delete this account.');
            }
        }
    }

    private static void restrictDeletionIfOpportunity(List<Account> accounts){
        List<Opportunity> opportunities = [SELECT AccountId FROM Opportunity];
        Set<Id> accountIds = new Set<Id>();

        for(Opportunity opportunity : opportunities) {
            accountIds.add(opportunity.AccountId);
        }
        for(Account account : accounts) {
            if(accountIds.contains(account.Id)) {
                account.addError('Opportunity Exists');
            }
        }
    }

    public static void restrictAccountDeleteIfCase(List<Account> accounts) { //Q16
        List<Case> cases = [SELECT AccountId FROM Case];
        Set<Id> accountIds = new Set<Id>();

        for(Case caseRecord : cases) {
            accountIds.add(caseRecord.AccountId);
        }
        for(Account account : accounts) {
            if(accountIds.contains(account.Id)) {
                account.addError('Case Exists');
            }
        }
    }

}