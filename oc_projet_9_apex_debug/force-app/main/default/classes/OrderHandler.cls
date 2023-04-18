public with sharing class OrderHandler {

    public static void processAccountAnnualRevenue(List<Order> orders) {

        Set<Id> setAccountIds = new Set<Id>();

        for (Order order : orders){
            setAccountIds.add(order.AccountId);
        }

        List<Account> accounts = AccountManager.getAccountsWithAnnualRevenue(setAccountIds);

        List<Order> activatedOrders = OrderManager.getOrdersActivatedByAccountId(setAccountIds);
        

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