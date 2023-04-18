public without sharing class MyTeamOrdersController {

     public decimal sumOrders{
        get{
            AggregateResult aggregateResult = OrderManager.getSumOfTotalAmountOfActivatedOrders();
			return (decimal)aggregateResult.get('total');

        }
        set;
    }
}