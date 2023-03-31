public with sharing class EmployeeTriggerHandler {

    public static void beforeInsert(List<Employee__c> newList) {      //NOPMD
    }

    public static void afterInsert(List<Employee__c> newList) {     //NOPMD
    }

    public static void beforeUpdate(List<Employee__c> newList, Map<Id, Employee__c> oldMap) { //NOPMD
    }

    public static void afterUpdate(List<Employee__c> newList, Map<Id, Employee__c> oldMap) { //NOPMD
    }

    public static void beforeDelete(List<Employee__c> oldList) { //NOPMD
    }

    public static void afterDelete(List<Employee__c> oldList) { //NOPMD
        employeeDeletedUpdateAccount(oldList);
        employeeDeletedUpdateAccount(oldList);
    }

    public static void afterUndelete(List<Employee__c> newList){  //NOPMD
        undeletingEmployeeSetActive(newList);
        employeeDeletedUpdateAccount(newList);
    }

    private static void employeeDeletedUpdateAccount(List<Employee__c> employees){ //Q17

        Set<Id> accountIds = new Set<Id>();
        for (Employee__c employee : employees) {
            accountIds.add(employee.AccountId__c);
        }
        List<Account> accountsToUpdate = new List<Account>();
        for (AggregateResult resultArray : [SELECT AccountId__c accId, COUNT(Id) countEmployee FROM Employee__c WHERE AccountId__c IN :accountIds GROUP BY AccountId__c]) {  //NOPMD
            Account accountUpdate = new Account(Id = (Id)resultArray.get('accId'), Left_Employee_Count__c = (Integer)resultArray.get('countEmployee'));
            accountsToUpdate.add(accountUpdate);
        }
        update accountsToUpdate; //NOPMD
    }

    private static void undeletingEmployeeSetActive(List<Employee__c> employeeList){       //Q18
        Set<String> employeeIds = new Set<String>();
        for (Employee__c employee : employeeList) {
            employeeIds.add(employee.Id);
        }
        List<Employee__c> employeequery = [SELECT Active__c FROM Employee__c WHERE Id IN :employeeIds];        //NOPMD
        for(Employee__c employee : employeequery) {
            employee.Active__c  = True;
        }
        update employeequery;    //NOPMD
    }

}