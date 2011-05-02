public class GenericLookupFieldComponentController {
    public MedicalRecord__c med;
    public String field { get; set; }
    public String fieldnameFieldName { get; set; }                              
    public String nameFieldName { get; set; }                              
    public String nameFieldReference;
    
    public String getNameFieldReference() {
        String name = Schema.SObjectType.MedicalRecord__c.fields.getMap().get(field) + '';
        System.debug('getNameFieldReference: ' + name);
        name = name.replace('__c','__r');
        System.debug('getNameFieldReference: ' + name);
        return name;        
    }
    
    
    public void setMed (MedicalRecord__c medX) {
        med = medX;        
        try{
            String objectName = Schema.SObjectType.MedicalRecord__c.fields.getMap().get(field).getDescribe().getReferenceTo().get(0).getDescribe().getName();
//            String query = 'Select Name, Id from ' + objectName + ' where Id = \'' + med.get(field) + '\'';
            String query = 'Select ' + nameFieldName + ' , Id from ' + objectName + ' where Id = \'' + med.get(field) + '\'';
            System.debug(query+ ' ' + nameFieldReference); 
            List<sObject> re = Database.query(query);
            if (re.size() > 0) {
                    med.putSObject(Schema.SObjectType.MedicalRecord__c.fields.getMap().get(field),re.get(0));
                }
        } catch (Exception e) {}
        
    }
    
    public MedicalRecord__c getMed() {
        return med;
    }
            
}