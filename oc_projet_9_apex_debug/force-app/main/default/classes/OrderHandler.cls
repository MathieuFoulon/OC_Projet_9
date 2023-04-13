public with sharing class OrderHandler {

    public static void processAccountAnnualRevenue(List<Order> Orders) {

        set<Id> setAccountIds = new set<Id>();

        for (Order order : Orders){
            setAccountIds.add(order.AccountId);
        }

        List<Account> accounts = [SELECT Id, AnnualRevenue FROM Account WHERE Id IN :setAccountIds]; 


        List<Order> activatedOrders =  [SELECT Id, TotalAmount, AccountId, Status FROM Order WHERE AccountId IN :setAccountIds AND Status = 'Activated'];

        for(Account account: accounts) {
            account.AnnualRevenue = 0;
            for(integer i=0; i < activatedOrders.size(); i++){
                if(activatedOrders[i].AccountId == account.Id) {
                account.AnnualRevenue += activatedOrders[i].TotalAmount;
                }
            }
        }

        if (accounts.size() > 0){
            update accounts;
        }
}
}