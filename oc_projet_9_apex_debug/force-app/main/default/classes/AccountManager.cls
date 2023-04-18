public with sharing class AccountManager {
    public static List<Account> getAccountsWithAnnualRevenue(Set<Id> accountsIds){
        return [SELECT Id, AnnualRevenue FROM Account 
        WHERE Id 
        IN :accountsIds
        ]; 
    }
}