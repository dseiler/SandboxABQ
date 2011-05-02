public class OrderItemListComponentController {
    public List<List<String>> fields = null;
    public String[] fieldList { get; set; }  
    
    public OrderItemListComponentController () {
    }    
    
      public List<List<String>> getFields() {
        if (fields== null) {
            fields = new List<List<String>>();
            for (Integer i = 0; i < fieldList.size(); i = i + 2) {
            System.debug(i);
                fields.add(new List<String>{fieldList[i],fieldList[i+1]} );            
            }
        }     
        return fields ;
    }    
        
        
}