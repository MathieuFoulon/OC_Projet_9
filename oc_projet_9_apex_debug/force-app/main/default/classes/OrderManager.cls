public with sharing class OrderManager {
    public static List<Order> getOrdersActivatedByAccountId(Set<Id> accountsIds){
        return  [SELECT Id, TotalAmount, AccountId, Status FROM Order 
        WHERE AccountId 
        IN :accountsIds AND Status = 'Activated'
        ];
    }

    public static AggregateResult getSumOfTotalAmountOfActivatedOrders(){
        AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Activated'];
		return groupedResults;
    }

    public static List<AggregateResult> getSumOfTotalAmountOfActivatedOrdersGroupedByAccounts(List<Account> accounts){
        return [SELECT SUM(TotalAmount) total, AccountId FROM Order 
            WHERE AccountId  
            IN :accounts AND Status='Activated' 
            GROUP BY AccountId 
        ];
    }
}