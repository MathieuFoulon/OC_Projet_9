public with sharing class DataFactory {
     
    public static Account createAccount(String accountName) {
            
        return new Account(Name = accountName);
    }

    public static Product2 createProduct(String productName) {
        
        return new Product2(Name= productName, IsActive = true);
    }

    public static PricebookEntry createPricebookEntry (String product2Id, Double unitPrice) {
            PricebookEntry pbe = new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = product2Id,
                UnitPrice = unitPrice,
                IsActive = true
            );
            return pbe;
    }

    public static Contract createContract(String accountId){
        Contract contract = new Contract(
            AccountId = accountId,
            Status = 'Draft',
            StartDate = Date.today(),
            ContractTerm = 3
        );
        return contract;
    }

    public static Order createOrder(String accountId){
        return new Order (AccountId = accountId, Pricebook2Id = Test.getStandardPricebookId(), Status = 'Draft', EffectiveDate = Date.today()+30);
    }

    public static List<Order> createOrders (String accountId, Integer ordsNumber){
        List<Order> ordersList = new List<Order>();
            for(Integer i=0; i < ordsNumber; i++) {
                Order ord = new Order (AccountId = accountId, Pricebook2Id = Test.getStandardPricebookId(), Status = 'Draft', EffectiveDate = Date.today()+30);
                ordersList.add(ord);
            }
        return ordersList;
    }

    

    public static List<OrderItem> createOrderItems (List<Order> ordersList, Map<String, String> data) {
        List<OrderItem> orderItems = new List<OrderItem>(); 
        for (Order ord: ordersList) {
            OrderItem oi1 = new OrderItem(
                OrderId = ord.Id,
                Product2ID = data.get('Product2Id'),
                PricebookEntryId = data.get('PricebookEntryId'),
                Quantity=20,
                UnitPrice = 100);
            orderItems.add(oi1);
        }
        return orderItems;
    }  

 }