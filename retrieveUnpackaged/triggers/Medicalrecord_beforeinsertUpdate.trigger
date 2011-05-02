trigger Medicalrecord_beforeinsertUpdate on MedicalRecord__c (before insert, before update) {
    System.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Medicalrecord_beforeinsertUpdate');
    for( MedicalRecord__c med : Trigger.new) {
    	if ( med.Equipment__c != null) {
			if (Trigger.isInsert) {
				List<MedicalRecord__c> duplicateEquiCheck = [Select Id, Name FROM MedicalRecord__c where Equipment__c = :med.Equipment__c];
				if (duplicateEquiCheck.size() > 0) {
					med.addError('Serial number already registered');							
				}									
			} else {
				List<MedicalRecord__c> duplicateEquiCheck = [Select Id, Name FROM MedicalRecord__c where Equipment__c = :med.Equipment__c and Id != :med.Id];	
				if (duplicateEquiCheck.size() > 0) {
					med.addError('Serial number already registered');							
				}									
			}    		
    	}        
    }
}