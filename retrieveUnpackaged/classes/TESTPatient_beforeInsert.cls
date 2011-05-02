@isTest
private class TESTPatient_beforeInsert {
	static {
		//Make sure that TESTInit static constructor is executed before starting Tests
		TESTInit.init();    	
    }

    static testMethod void checkPatientHasPredefinedOwner() {
        Patient__c patient = [Select OwnerId FROM Patient__c Where Id = :TESTInit.patients.get(0).Id];
        System.assertEquals(patient.OwnerId,SystemId__c.getInstance('UserId_PatientOwner').Value__c);
    }
}