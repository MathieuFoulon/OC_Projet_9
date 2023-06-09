public with sharing class UpdateAccountsAnnualRevenueBatch implements Database.Batchable<sObject>, Database.Stateful {

    public Integer recordsProcessed = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc){ 
        return Database.getQueryLocator('SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status=\'Activated\')');
 
    }
     
    public void execute(Database.BatchableContext bc, List<Account> scope){    
        
        List<AggregateResult> results = OrderManager.getSumOfTotalAmountOfActivatedOrdersGroupedByAccounts(scope);
        
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Account account : scope){
            for(AggregateResult result : results){
                if(account.id == result.get('AccountId')){
                    account.AnnualRevenue = (decimal)result.get('total');
                    accountsToUpdate.add(account);
                    recordsProcessed = recordsProcessed + 1;
                }
            }
        }
        
        if (accountsToUpdate.size() > 0){
            update accountsToUpdate;
        }
    }    
     
    public void finish(Database.BatchableContext bc){     
        System.debug('Batch done. Records processed : ' + recordsProcessed);
    } 
}