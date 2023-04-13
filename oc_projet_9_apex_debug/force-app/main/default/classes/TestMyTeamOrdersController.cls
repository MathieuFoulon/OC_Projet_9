@isTest
public with sharing class TestMyTeamOrdersController {
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

        PricebookEntry pricebookEntry = DataFactory.createPricebookEntry(product.id, 100);
        insert pricebookEntry;

        List<Contract> contractsList = new List<Contract>();
        List<Order> ordersList = new List<Order>();
        for(Account account : accounts){
            contractsList.add(DataFactory.createContract(account.id));
            for(Integer i = 0; i < 2; i++){
                ordersList.add(DataFactory.createOrder(account.id));
            }
            
        }
        insert contractsList;
        insert ordersList;

        Map<String,String> productIdAndPriceBookEntryIdMapped = new Map<String, String>{
            'Product2iD'=>product.id,
            'PricebookEntryId'=>pricebookEntry.id
        };

        
        List<OrderItem> orderItemsList = DataFactory.createOrderItems(ordersList, productIdAndPriceBookEntryIdMapped);
        insert orderItemsList;
        
    }
    @isTest
    public static void sumOrdersTest() {
        MyTeamOrdersController mtoc = new MyTeamOrdersController();

        List<Order> updatedOrders = new List<Order>();
        List<Order> orders = [SELECT Id, Status FROM Order WHERE Status = 'Draft'];
        for(Order order : orders){
            order.Status = 'Activated';
            updatedOrders.add(order);
        }
        

        Test.startTest();
        update updatedOrders;
        Test.stopTest();

        Decimal resultToShow = mtoc.SumOrders;
        // 10 account * 2 orders * 20 unit product * 100 unit price = 40000 €
        System.assertEquals(40000, resultToShow, ' wrong expectation : resultToShow = '+ resultToShow);

    }
}