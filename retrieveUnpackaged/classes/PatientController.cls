public with sharing class PatientController {
    public boolean access { get; set; }
    public String[] publicFields { get; set; }
    public String[] privateFields { get; set; }

    public PatientController(ApexPages.StandardController controller) {
/*        String publicFieldsString = 'PatientId__c';
        String privateFieldsString = 'Name,FirstName__c,MiddleName__c,LastName__c,MaidenName__c,Gender__c,Birthdate__c,Deceased__c,DateOfDecease__c,Street__c,PostalCode__c,City__c,State__c,Country__c,HomePhone__c,OfficePhone__c,MobilePhone__c,Email__c,Language__c,InsuranceName__c,PatientInsuranceId__c';        
    
        privateFields = privateFieldsString.split(',',0);
        publicFields = publicFieldsString.split(',',0);
        
        controller.addFields(privateFields);
        controller.addFields(publicFields);
        

        Set<String> fieldSet = new Set<String>();
        fieldSet.addAll(privateFields);
        fieldSet.addAll(publicFields);
        
        if (controller.getId() == null) {
//New Record        
            access = true;
        }
        else if (ApexPages.currentPage().getParameters().get('inline') == null  ) {
//Edit Modus        
//            access = true;
//            logAccess();
*/
//        }

/*
        if (qid == null) {
            patientObj = new Patient__c();
            access = true;
        } else {
        
            String query = 'Select ';
            for (String field : fieldSet) {
                query = query + field + ', ';
            }        
            query = query.substring(0,query.length() - 2) +  ' from Patient__c where Id = \'' + qid + '\'';
//            patientObj = Database.query('select Name, Id, ExplantDate__c from Patient__c where Id = \'' + qid + '\'');
            patientObj = Database.query(query);
        }
*/        
    }
    public PageReference access() {
//        writeLog(patient.Id, Datetime.now(), UserInfo.getUserId());
        logAccess();
        access = true;
        return null;
    }
    public PageReference logAccess() {
        String qid = ApexPages.currentPage().getParameters().get('id');
        if (qid != null) {
            Log__c log = new Log__c(Patient__c = qid);
            insert log;
        }
        return null;
    }
}