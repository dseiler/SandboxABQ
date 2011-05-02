trigger Patient_afterInsertUpdateDeleteUndelete on Patient__c (after delete, after insert, after undelete, after update) {


/*
    Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Patient__c.fields.getMap();
    
    
       
    for(Patient__c patient : Trigger.new) {
        Patient__c old_patient = Trigger.oldMap.get(patient.Id);
        for (String f : fieldMap.keySet()) {
            System.debug(f + ': ' + old_patient.get(f) + '=> ' + patient.get(f));
            if (old_patient.get(f) == patient.get(f)) {
            } else {
//              oldvalue = old_patient.get(f).toString(), .add(new Log__c(Patient__c = patient, field = f, oldvalue = old_patient.get(f).toString(), newvalue = patient.get(f).toString() ));
                
                System.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CHANGE');
                
            } 
        }   
    }    

    
//  insert logList;
    
    */
}