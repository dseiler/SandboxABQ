public with sharing class MedicalRecordController { 
    public MedicalRecord__c medicalRecord { get; set; }
    public RelationCustomerPatient__c custPatient { get; set; }
    public String json;

    public String pageTitle { get; set; }    
    public Boolean isSurgery { get; set; }
    public Boolean isActivation { get; set; }
    
    public String getJson() {
        List<String> fieldNames = new List<String>();
        fieldNames.addAll(Schema.SObjectType.MedicalRecord__c.fields.getMap().keySet());
        
        String s  = '{';
        for (String field : fieldNames) {
            if (medicalRecord.get(field) != null) {
                s += '"' + EncodingUtil.urlEncode(field,'UTF-8') + '": "' + EncodingUtil.urlEncode((medicalRecord.get(field) + ''),'UTF-8') + '",';
            }
        }
        
        s = s.substring(0, s.length() - 1) + '}';
        
        return s;
    }
    
 
    public MedicalRecordController(ApexPages.StandardController controller) {
        isSurgery = false;
        isActivation = false;
        List<String> fieldNames = new List<String>();
        fieldNames.addAll(Schema.SObjectType.MedicalRecord__c.fields.getMap().keySet());
        fieldNames.add('Customer__r.Name');
        fieldNames.add('Patient__r.Name');
        fieldNames.add('Professional__r.Name');
        fieldNames.add('Equipment__r.Name');
//            fieldNames.add('Equipment__r.SerialNumber__c');
        controller.addFields(fieldNames);
                

        medicalRecord = (MedicalRecord__c)controller.getRecord();
        String recordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        if (controller.getId() == null) {
            if (recordTypeId != null) {
                medicalRecord.RecordTypeId = recordTypeId;
            } else {
//fehler
            }
        }
        
        if (medicalRecord.Customer__c != null && medicalRecord.Patient__c != null) {
                List<RelationCustomerPatient__c> custPatientList = [Select Id, Patient__c, Customer__c, ClinicPatientId__c FROM RelationCustomerPatient__c where Patient__c =:medicalRecord.Patient__c and Customer__c =:medicalRecord.Customer__c];
                if (custPatientList.size() == 1) {
                    custPatient = custPatientList.get(0);
                }
            }
        
        if (medicalRecord.RecordTypeId == SystemId__c.getInstance('RecordType_ActivationReport').Value__c) {
            isActivation = true;
            pageTitle = 'Product Registration';
        } else if (medicalRecord.RecordTypeId == SystemId__c.getInstance('RecordType_SurgeryReport').Value__c) {
            isSurgery = true;
            pageTitle = 'Surgery Report';
        } 
    }
    
    public PageReference changedAction() {
        /*try {
            if (medicalRecord.Surgery__c != null) {
                if (medicalRecord.Id == null) {
                    medicalRecord.Patient__c = [Select Patient__c FROM MedicalRecord__c where Id = :medicalRecord.Surgery__c].Patient__c ;
                    medicalRecord.Patient__r = [Select Id, Name FROM Patient__c where Id = :medicalRecord.Patient__c];
                }
            }
        } catch (System.StringException ex) {}
        */
        try {
            if (medicalRecord.Equipment__c != null) {
                medicalRecord.Material__c = [Select Material__c FROM Equipment__c where Id = :medicalRecord.Equipment__c].Material__c ;
                medicalRecord.Material__r = [Select Id, Name FROM Material__c where Id = :medicalRecord.Material__c];
            }
        } catch (System.StringException ex) {
//is not an id, so there has to be null in the field
            medicalRecord.Equipment__c = null;
            medicalRecord.Equipment__r = new Equipment__c();        
        }
        try {
            if (medicalRecord.Customer__c != null && medicalRecord.Patient__c != null) {
                List<RelationCustomerPatient__c> custPatientList = [Select Id, Patient__c, Customer__c, ClinicPatientId__c FROM RelationCustomerPatient__c where Patient__c =:medicalRecord.Patient__c and Customer__c =:medicalRecord.Customer__c];
                if (custPatientList.size() == 1) {
                    custPatient = custPatientList.get(0);
                }
            }
        } catch (System.StringException ex) {
//is not an id, so there has to be null in the field
            medicalRecord.Equipment__c = null;
            medicalRecord.Equipment__r = new Equipment__c();        
        }
        

        
        return null;
    }



    public PageReference cust_save() {
        PageReference ref;
        ApexPages.StandardController sc = new ApexPages.StandardController(medicalRecord);
        Savepoint sp = Database.setSavepoint();
        try { 
            ref = sc.save();
            if (!ApexPages.hasMessages()) {
//                if (medicalRecord.RecordTypeId == SystemId__c.getInstance('RecordType_SurgeryReport').Value__c) {
                //create RelationCustomerPatient__c if its not there already
                if (medicalRecord.Patient__c != null && medicalRecord.Customer__c != null) {
                    List<RelationCustomerPatient__c> custPatientList = [Select Id, Patient__c, Customer__c, ClinicPatientId__c FROM RelationCustomerPatient__c where Patient__c =:medicalRecord.Patient__c and Customer__c =:medicalRecord.Customer__c];
                    if (custPatientList.size() == 0) {
                            custPatient.Customer__c = medicalRecord.Customer__c ;
                            custPatient.Patient__c = medicalRecord.Patient__c ;
                            insert custPatient;
//                        insert new RelationCustomerPatient__c(Patient__c = medicalRecord.Patient__c, Customer__c = medicalRecord.Customer__c);
                    } else {
                        if (!custPatientList.get(0).ClinicPatientId__c.equalsIgnoreCase(custPatient.ClinicPatientId__c)) {
                            custPatientList.get(0).ClinicPatientId__c = custPatient.ClinicPatientId__c;
                        update custPatientList.get(0);
                        }
                    }        
                } 
                if (medicalRecord.Professional__c != null && medicalRecord.Patient__c  != null) {     
                    List<RelationProfessionalPatient__c> profPatientList = [Select Professional__c, Patient__c From RelationProfessionalPatient__c where Professional__c=:medicalRecord.Professional__c and Patient__c =:medicalRecord.Patient__c];
                    if (profPatientList.size() == 0) {
                        insert new RelationProfessionalPatient__c (Professional__c = medicalRecord.Professional__c , Patient__c = medicalRecord.Patient__c);
                    }           
                }
                
                if (medicalRecord.Professional__c != null && medicalRecord.Customer__c != null) {
                    List<RelationCustomerProfessional__c> custProfList = [Select Id, Professional__c, Customer__c, Active__c From RelationCustomerProfessional__c where Professional__c=:medicalRecord.Professional__c and Customer__c=:medicalRecord.Customer__c];        
                    if (custProfList.size() == 0) {
                        insert new RelationCustomerProfessional__c (Professional__c = medicalRecord.Professional__c, Customer__c = medicalRecord.Customer__c, Active__c = true, StartDate__c = Date.today());
                    } else if (custProfList.get(0).Active__c == false) {               
                        custProfList.get(0).Active__c = true;
                        upsert custProfList.get(0);
                    } 
                }                   
            }                
        } catch (System.Exception e) {            
            Database.rollback(sp);
            ref = ApexPages.currentPage();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error'));                
        } 
       
        return ref;
    }
}