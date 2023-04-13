@isTest
public with sharing class TestUpdateAccountsAnnualRevenueBatch {
    @TestSetup
    static void makeData(){

        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 10; i++){
            Account account = DataFactory.createAccount('accountTest' + i);
            accounts.add(account);
        }
        insert accounts;

        Product2 product = DataFactory.createProduct('Char Tigre');
        insert product;

        PricebookEntry pricebookEntry = DataFactory.createPricebookEntry(product.id, 1000);
        insert pricebookEntry;

        List<Contract> contractsList = new List<Contract>();
        List<Order> ordersList = new List<Order>();
        for(Account account : accounts){
            contractsList.add(DataFactory.createContract(account.id));
            for(Integer i = 0; i < 101; i++){
                ordersList.add(DataFactory.createOrder(account.id));
            }
            
        }
        insert contractsList;
        insert ordersList;

        Map<String,String> productIdAndPriceBookEntriIdMapped = new Map<String, String>{
            'Product2iD'=>product.id,
            'PricebookEntryId'=>pricebookEntry.id
        };

        
        List<OrderItem> orderItemsList = DataFactory.createOrderItems(ordersList, productIdAndPriceBookEntriIdMapped);
        
        
        insert orderItemsList;



    }
    @isTest 
    public static void accountsAnnualRevenueBatchTest() {
        List<Order> orders = [SELECT Id, Status FROM Order LIMIT 150];
        for(Order order: orders){
            order.status = 'Activated';
        }
        update orders;

        Test.startTest();
        UpdateAccountsAnnualRevenueBatch uaarb = new UpdateAccountsAnnualRevenueBatch();
        Id batchId = Database.executeBatch(uaarb);
        Test.stopTest();
        String content = '%testAccount%';
        List<Account> accounts = [SELECT Id, AnnualRevenue, NAME FROM Account WHERE Name LIKE :content];
        // 101 orders * 20 unit product * 100 unit price = 202000 € for each 10 accounts
        for(Account account : accounts){
            System.assertEquals(202000, account.AnnualRevenue, 'wrong annual revenue on account' + account);
        }
        
    }
}