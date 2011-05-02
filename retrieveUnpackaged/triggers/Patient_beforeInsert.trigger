trigger Patient_beforeInsert on Patient__c (before insert) {
    for(Patient__c patient : Trigger.new) {
        patient.OwnerId = SystemId__c.getInstance('UserId_PatientOwner').Value__c;
    }
}