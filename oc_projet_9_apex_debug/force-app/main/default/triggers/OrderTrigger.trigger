trigger OrderTrigger on Order (after update) {
    System.debug('trigger hehehehehe');
    OrderHandler.processAccountAnnualRevenue(trigger.new);
} 