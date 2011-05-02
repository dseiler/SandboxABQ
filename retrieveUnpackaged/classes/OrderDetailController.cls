public with sharing class OrderDetailController {
    public Order__c order { get; set; }    
    public list<Delivery__c> deliveries { get; set; }
    public list<Delivery__c> returnDeliveries { get; set; }

    public list<OrderItem__c> orderItems { get; set; }
    public String[] orderItemFieldList { get; set; }
    public list<OrderItem__c> returnOrderItems { get; set; }
    public String[] returnOrderItemFieldList { get; set; } 

    public String[] deliveryItemFieldList { get; set; }
    public String[] returnDeliveryItemFieldList { get; set; }
    
    public OrderDetailController(ApexPages.StandardController controller) {
        this.order = (Order__c)controller.getRecord();
        
        orderItems = [Select Id, Name, Material__c, SapMaterialNumber__c, OrderQuantity__c, ItemType__c from OrderItem__c where Delivery__c = null and ItemType__c = 'out'];
        orderItemFieldList = new String[]{
            'ItemType__c','Item Type',
            'Material__c','Model No',
            'OrderQuantity__c','Quantity'
            };
            
        returnOrderItems = [Select Id, Name, Material__c, SapMaterialNumber__c, OrderQuantity__c, ItemType__c from OrderItem__c where Delivery__c = null and ItemType__c = 'in'];
        returnOrderItemFieldList = new String[]{
            'ItemType__c','Item Type',
            'Material__c','Model No',
            'OrderQuantity__c','Quantity',
            'ItemType__c','ItemType__c'};
            
            
//        deliveries = [Select Id, Name, GoodsIssueDate__c from Delivery__c where Order__c =:this.order.Id and DeliveryType__c = 'out'];
        deliveries = [Select Id, Name, GoodsIssueDate__c from Delivery__c where Order__c =:this.order.Id];
            
        deliveryItemFieldList = new String[]{
            'ItemType__c','Item Type',
            'Material__c','Model No',
            'OrderQuantity__c','Quantity'
            };

        returnDeliveries = [Select Id, Name, GoodsIssueDate__c from Delivery__c where Order__c =:this.order.Id and DeliveryType__c = 'in'];

        returnDeliveryItemFieldList = new String[]{
            'ItemType__c','Item Type',
            'Material__c','Model No',
            'OrderQuantity__c','Quantity'};
    }
}