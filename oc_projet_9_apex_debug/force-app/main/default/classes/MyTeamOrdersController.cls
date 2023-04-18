public without sharing class MyTeamOrdersController {

     public decimal sumOrders{
        get{
			return (decimal)OrderManager.getSumOfTotalAmountOfActivatedOrders();

        }
        set;
    }
}