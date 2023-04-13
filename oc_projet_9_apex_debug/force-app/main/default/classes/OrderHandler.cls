public with sharing class OrderHandler {

    public static void processAccountAnnualRevenue(List<Order> Orders) {
        System.debug('coucou');
        set<Id> setAccountIds = new set<Id>();

        //Add account Id in a set for each orders
        for (Order newOrder : Orders){
            setAccountIds.add(newOrder.AccountId);
        }

        // Get the list of account related to new orders
        List<Account> accounts = [SELECT Id, AnnualRevenue FROM Account WHERE Id IN :setAccountIds]; 

        // Get the new orders 
        List<Order> activatedOrders =  [SELECT Id, TotalAmount, AccountId, Status FROM Order WHERE AccountId IN :setAccountIds AND Status = 'Activated'];
        System.debug(activatedOrders);
        // Update turnover for each account and add them to our collection
        for(Account account: accounts) {
            account.AnnualRevenue = 0;
            for(integer i=0; i < activatedOrders.size(); i++){
            if(activatedOrders[i].AccountId == account.Id) {
            account.AnnualRevenue += activatedOrders[i].TotalAmount;
            }
            }
        }
        System.debug(accounts);
        if (accounts.size() > 0){
            update accounts;
            }
}
}