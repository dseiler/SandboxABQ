public with sharing class MedicalRecordLookupController { 
    public Integer pageNumber {get; set;}
    public Integer totalPageNumber {get; set;}

    public String debug { get; set; }

    public String query {get; set;}
    public String medicalDataJson {get; set;}
    public List<sObject> resultItems {get; set;}
    public List<List<String>> resultFieldList = null;
    
    public List<List<String>> filterCriteria = null;

    public String lookupField = null;
    
    public MedicalRecordLookupController(ApexPages.StandardController controller) {
        updateTablePage();
    }
    
    public String getLookupField() {
        if (lookupField == null) {
            lookupField = ApexPages.currentPage().getParameters().get('Field'); 
        }
        return lookupField;
    }

    public List<List<String>> getFilterCriteria () {
        filterCriteria = new List<List<String>>();
        String field = getLookupField();
        try {
            if (medicalDataJson != null) {        
                JSONObject medicalJSON = new JSONObject( medicalDataJson);
/*   Professional is using the standard lookup for now                
                if (field.equalsIgnoreCase('Professional__c')) {            
                    if (medicalJSON.has('customer__c')) {      
                        filterCriteria.add(new List<String>{'Customer',[Select Name From Account where Id = :medicalJSON.getString('customer__c')].Name});                  
                    }                                                    
                } else
*/                 
                if (field.equalsIgnoreCase('Equipment__c')) {            
                    if (medicalJSON.has('material__c')) {      
                        filterCriteria.add(new List<String>{'Material',[Select Name From Material__c where Id = :medicalJSON.getString('material__c')].Name});                  
                    }                                                    
                }
            }                
        } catch (JSONObject.JSONException e) {
       
        }                            
        return filterCriteria ;
    }
    
    public PageReference runQuery()
    {
        if (medicalDataJson == null || medicalDataJson.equalsIgnoreCase('')) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please wait' ));
            return null;
        }
    
        String field = getLookupField();
        try {

            JSONObject medicalJSON = new JSONObject( medicalDataJson);
System.debug('&&&&&&&&& Start Query: Query       = ' + query);
System.debug('&&&&&&&&&              medicalJSON = ' + medicalJSON );
System.debug('&&&&&&&&&              field       = ' + field );

/*   Professional is using the standard lookup for now
            if (field.equalsIgnoreCase('Professional__c')) { 
                String contactRecordType;
                if (medicalJSON.getString('recordtypeid').substring(0,15) == SystemId__c.getInstance('RecordType_ActivationReport').Value__c.substring(0,15)) {
                    contactRecordType = SystemId__c.getInstance('RecordType_Audiologist').Value__c;                
                } else if (medicalJSON.getString('recordtypeid').substring(0,15) == SystemId__c.getInstance('RecordType_SurgeryReport').Value__c.substring(0,15)) {
                    contactRecordType = SystemId__c.getInstance('RecordType_Surgeon').Value__c;                
                } 
                                       
                if (query == '' || query == '*') {
                    if (medicalJSON.has('customer__c')) {
                        List<RelationCustomerProfessional__c> rel = [SELECT Professional__c, Customer__c FROM RelationCustomerProfessional__c WHERE Customer__c = :medicalJSON.getString('customer__c')];
                        List<Id> ids = new List<Id>();
                        
                        for (RelationCustomerProfessional__c r : rel ) {
                            ids.add(r.Professional__c);   
                        }

                        resultItems =  [Select Id, Name,ProfessionalId__c FROM Contact where recordtypeid =:contactRecordType and Id in :ids];                   
                    }
                    else {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Empty search only allowed with selected customer' ));
                        return null;
                    }
                } else if (query.replace('*','').length() > 1) {
                    List<List<Contact>> searchResults=[FIND :query IN ALL FIELDS RETURNING Contact (id, name,ProfessionalId__c where recordtypeid =:contactRecordType)];
                    
                    if (medicalJSON.has('customer__c')) {
                        debug = 'customer__c : ' + medicalJSON.getString('customer__c');
                        Map<Id, Contact> contactMap = new Map<Id, Contact>();
                        List<Id> ids = new List<Id>();
                        
                        for (Contact c : searchResults[0]) {
                            ids.add(c.Id);   
                            System.debug( c.Id);            
                            contactMap.put(c.id, (Contact)c);
                        }
        
                        List<RelationCustomerProfessional__c> dd = [SELECT Professional__c, Customer__c FROM RelationCustomerProfessional__c WHERE Professional__c IN :ids and Customer__c = :medicalJSON .getString('customer__c')];
                        resultItems = new List<sObject>();
                        for (RelationCustomerProfessional__c r : dd) {
                            System.debug( r.Professional__c + ' ' + r.Customer__c);            
                            resultItems.add(contactMap.get(r.Professional__c));
                        }
                    } else {
                        resultItems = searchResults[0];
                    }                                    
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Search text to short' ));
                    return null;                
                }                                    
            } else
*/             
            if (field.equalsIgnoreCase('Equipment__c') || field.equalsIgnoreCase('ReplacedDevice__c')) {    
                if (query == '' || query == '*') {    
                    if (medicalJSON.has('material__c')) {    
                        resultItems = [Select Id, Name, EquipmentNumber__c, SerialNumber__c, Material__c, SapMaterialNumber__c, MaterialDesc__c, Material__r.Name FROM Equipment__c where Material__c =:medicalJSON.getString('material__c')];
                    }
                    else {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Empty search only allowed with selected material' ));
                        return null;
                    }                                     
                } else if (query.replace('*','').length() > 1) {
                        List<List<Equipment__c>> searchResults=[FIND :query IN ALL FIELDS RETURNING Equipment__c (Id, Name, EquipmentNumber__c, SerialNumber__c, Material__c, SapMaterialNumber__c, MaterialDesc__c, Material__r.Name)];
                        
                        if (medicalJSON.has('material__c')) {
                            resultItems = new List<Equipment__c>(); 
                            for (Equipment__c eq : searchResults[0]) {
                                if (medicalJSON.getString('material__c').equalsIgnoreCase(eq.Material__c) ) {
                                    resultItems.add(eq);
                                }
                            }                            
                        } else {
                            resultItems = searchResults[0];
                        }
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Search text to short' ));
                    return null;                
                } 
            } 
        } catch (JSONObject.JSONException e) {
           
        }
        updateTablePage();
        return null;
    }

    


//Patient__c specific



    public String clinicPatientId {get; set;}
    public Patient__c patient;
    public Patient__c getPatient() {
        if (patient == null) {
            patient = new Patient__c(); 
        }
        return patient;
    }    
    public Patient__c selectedPatient;
    public Patient__c getSelectedPatient() {
        return selectedPatient;
    }

    public PageReference runPatientSelect() {
        List<Patient__c> results = [Select Id, Name from Patient__c Where PatientId__c = :patient.PatientId__c];
        if (results.size() == 1) {
            selectedPatient = results.get(0);
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Patient not found'));
            selectedPatient = new Patient__c();
        }
        return null;
    }
    public PageReference runDetailSearch() {
        List<Patient__c> detailQueryResult;
        String queryString = 'Select (Select ClinicPatientId__c From RelationsCustomerPatient__r),Id, Name,PatientId__c,FirstName__c,LastName__c,Gender__c,Birthdate__c,City__c,Country__c From Patient__c where ';
        if ((patient.LastName__c != null) && (patient.LastName__c != '')) {
            queryString += ' LastName__c like \'' + patient.LastName__c.replace('*','%') + '\' and  ';           
        }
        if ((patient.BirthDate__c != null)) {
            queryString += ' BirthDate__c = ' + String.valueOf(patient.BirthDate__c) + ' and  ';           
        }
        System.debug(queryString);
        queryString = queryString.subString(0,queryString.length() - 5);
        System.debug(queryString);
        detailQueryResult = Database.query(queryString );
        
        Set<Patient__c> res = new Set<Patient__c>();
        if ((clinicPatientId != null) && (clinicPatientId != '')) {
            for (Patient__c p : detailQueryResult) {
                for (RelationCustomerPatient__c r : p.RelationsCustomerPatient__r) {
                    if ( clinicPatientId.equalsIgnoreCase(r.clinicPatientId__c)) {
                        res.add(p);        
                    }
                }    
            }                       
            detailQueryResult = new List<Patient__c>();
            for (Patient__c p : res) {
                detailQueryResult.add(p);
            }
        }

        logResults(detailQueryResult);
        resultItems = detailQueryResult;
        updateTablePage();
        
        return null;
    }

    public void updateTablePage() {
        pageNumber = 1;
        if (resultItems != null) {
            if (resultItems.size() > 0) {
                totalPageNumber = ((resultItems.size() - 1 ) / 5 ) + 1;    
            } else {
                totalPageNumber = 0;
            }
        } else {
            totalPageNumber = 0;
        }
    }


    public List<List<String>> getResultFieldList() {
        if (resultFieldList == null) {
            String field = getLookupField();
            if (field.equalsIgnoreCase('Professional__c')) {
                resultFieldList = new List<List<String>>
                {
                    new List<String>{'ProfessionalId__c','Professional Id'},
                    new List<String>{'Name','Name'}
                };
            } else if (field.equalsIgnoreCase('Patient__c')) {
                resultFieldList = new List<List<String>>
                {
                    new List<String>{'PatientId__c','Patient Id'},
                    new List<String>{'FirstName__c','First Name'},
                    new List<String>{'LastName__c','Last Name'},
                    new List<String>{'Gender__c','Gender'},
                    new List<String>{'Birthdate__c','Birthdate'},
                    new List<String>{'City__c','City'},
                    new List<String>{'Country__c','First Country'}
                };
            } else if (field.equalsIgnoreCase('Equipment__c') || field.equalsIgnoreCase('ReplacedDevice__c')) {
                resultFieldList = new List<List<String>>
                {
                    new List<String>{'Name','Serial number'},
                    new List<String>{'Material__r.Name','Model Number'},
                    new List<String>{'SapMaterialNumber__c','SAP Material number'},
                    new List<String>{'MaterialDesc__c','Material description '}
                };
            } else if (field.equalsIgnoreCase('')) {
                resultFieldList = new List<List<String>>
                {
                    new List<String>{'Id','Id'},
                    new List<String>{'Name','Name'}
                };
            } else {
            }               
        }            
        updateTablePage();
        return resultFieldList;
    }    

    public void logResults(List<Patient__c> queryResult){
        List<Log__c> logs = new List<Log__c>();
        for (Patient__c p : queryResult) {
            logs.add(new Log__c(Patient__c = p.id, AccessType__c='Searchresult'));
        }
        insert logs;
    }


    public PageReference resultNextPage() {
        if (pageNumber == null) {
            pageNumber = 0;        
        }
        pageNumber= pageNumber+ 1;    
        return null;
    }
    
    public PageReference resultPreviousPage() {
        pageNumber= pageNumber- 1;    
        if (pageNumber < 0) 
            pageNumber = 0;
        return null;
    }
    

























    public PageReference getCurrentPage() {
        return ApexPages.currentPage();
    }





}