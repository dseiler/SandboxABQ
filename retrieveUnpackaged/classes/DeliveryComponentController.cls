public class DeliveryComponentController {
    public list<OrderItem__c> orderItems = null;
    public Delivery__c delivery { get; set; }

    
    public list<OrderItem__c> getOrderItems() {
        if (orderItems == null) {
            orderItems = [Select Id, Name, Material__c, SapMaterialNumber__c, OrderQuantity__c, ItemType__c from OrderItem__c where Delivery__c =:delivery.Id]; 
        }     
        return orderItems ;
    }    
        
    public DeliveryComponentController() {
    }
}