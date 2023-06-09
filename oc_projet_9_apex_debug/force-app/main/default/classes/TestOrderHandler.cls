@isTest
public with sharing class TestOrderHandler {
    @TestSetup
    static void makeData(){
        Account account =  DataFactory.createAccount('AccountTest1');
        insert account;
        Product2 product = DataFactory.createProduct('ProductTest1');
        insert product;
        PricebookEntry pricebookEntry = DataFactory.createPricebookEntry(product.id, 100);
        insert pricebookEntry;
        Contract contract = DataFactory.createContract(account.id);
        insert contract;
        List<Order> orders = DataFactory.createOrders(account.id, 1);
        insert orders;

        Map<String,String> productIdAndPriceBookEntryIdMapped = new Map<String, String>{
            'Product2iD'=>product.id,
            'PricebookEntryId'=>pricebookEntry.id
        };

        List<OrderItem> orderItems = DataFactory.createOrderItems(orders, productIdAndPriceBookEntryIdMapped);

        insert orderItems;
    }

    // TESTING FORMULA WORKED WELL = NOT APEX CODED IN ORDERHANDLER CLASS !!!
    @isTest
    static void processNetAmountTest(){
        Order order = new Order();
        order = [SELECT Id, Shipment_Cost__c, Net_Amount__c, TotalAmount FROM Order LIMIT 1];
        
        Test.startTest();
        System.assertEquals(0, order.Shipment_Cost__c, 'shipment cost null or not 0');

        // updating shipment cost to verify that the formula updates well
        order.Shipment_Cost__c = 200;
        update order;
        
        Test.stopTest();

        Decimal netAmount = ([SELECT Net_Amount__c FROM Order WHERE Id=:order.Id].Net_Amount__c);
        // 1 order * 20 unit product * 100 unit price - 200 shipment cost = 1800 € 
        System.assertEquals(1800, netAmount, 'Net_Amount__c is not equal 1800, need to check DataFactory and Shipment__Cost__c added');
        
    }

    @isTest
    static void processAccountAnnualRevenueTest(){
        Order order = [SELECT Id, Status FROM Order WHERE Status = 'Draft'];

        Test.startTest();
        order.Status = 'Activated';
        update order;
        Test.stopTest();

        Decimal annualRevenue = ([SELECT Id, AnnualRevenue FROM Account WHERE Name = 'AccountTest1'].AnnualRevenue);
        // 1 order * 20 unit product * 100 unit price = 2000 € 
        System.assertEquals(2000, annualRevenue, 'AnnualRevenue not equal to 2000 :' + annualRevenue );
    }
}