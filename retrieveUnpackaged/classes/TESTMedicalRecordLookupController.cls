@isTest
private class TESTMedicalRecordLookupController {

	static {
		//Make sure that TESTInit static constructor is executed before starting Tests
		TESTInit.init();    	
    }


    static MedicalRecordLookupController runQueryTest(String field, String query, String json) {
        PageReference ref = Page.MedicalRecordLookup;
        Test.setCurrentPage(ref);
        
        MedicalRecordLookupController ext = new MedicalRecordLookupController(new Apexpages.Standardcontroller(new MedicalRecord__c()));
                
        ApexPages.currentPage().getParameters().put('Field', field);            
        
        ext.medicalDataJson = json;
        ext.query = query;
        ext.runQuery();
        return ext;            
    }

    static MedicalRecordLookupController runDetailSearch(String field, String json, Patient__c selectionPatient) {
        PageReference ref = Page.MedicalRecordLookup;
        Test.setCurrentPage(ref);
        
        MedicalRecordLookupController ext = new MedicalRecordLookupController(new Apexpages.Standardcontroller(new MedicalRecord__c()));
                
        ApexPages.currentPage().getParameters().put('Field', field);            
        
        ext.medicalDataJson = json;
        ext.patient = selectionPatient;
        ext.runDetailSearch();
        return ext;            
    }









    static testMethod void filterTest() {
        try
        {
            //Query with no filtered material and empty query should give a warning             
            MedicalRecordLookupController ext = runQueryTest('Equipment__c', '', '{}');
            System.assert(ApexPages.hasMEssages());
        }
        catch (System.Exception e)
        {
            System.debug('**** Exception occured in test method filterTest: ' + e);
            System.assert(false);
        }        
    }
    static testMethod void filterTest2() {
        try
        {
            //Query with no filtered material and a query, that is too short,  should give a warning            
            MedicalRecordLookupController ext = runQueryTest('Equipment__c', 'e*', '{}');
            System.assert(ApexPages.hasMEssages());
        }
        catch (System.Exception e)
        {
            System.debug('**** Exception occured in test method filterTest2: ' + e);
            System.assert(false);
        }        
    }
     
    static testMethod void filterTest3() {
        try
        {
            //Should return the two (or more) TESTInit.equipments that start with eq 
            Test.setFixedSearchResults(new Id[]{TESTInit.equipments.get(0).Id,TESTInit.equipments.get(1).Id});
                        
            MedicalRecordLookupController ext = runQueryTest('Equipment__c', 'eq', '{}');
            
            
            Set<Id> availEqipmentIds = new Set<Id>{TESTInit.equipments.get(0).Id,TESTInit.equipments.get(1).Id};
            Set<Id> returnedEqipmentIds = new Set<Id>();
            for (Sobject o : ext.resultItems) {
                returnedEqipmentIds.add(o.Id);                  
            }                        
            System.assert(returnedEqipmentIds.containsAll(availEqipmentIds),'Error in search');
        }
        catch (System.Exception e)
        {
            System.debug('**** Exception occured in test method filterTest3: ' + e);
            System.assert(false);
        }        
    }

    static testMethod void filterTest4() {
        try
        {
            //should not return the equipment, that is not related to the filter material 
            Test.setFixedSearchResults(new Id[]{TESTInit.equipments.get(0).Id,TESTInit.equipments.get(1).Id});
                        
            MedicalRecordLookupController ext = runQueryTest('Equipment__c', '', '{ "material__c" : "' + TESTInit.materials.get(0).Id + '"}');
            
            
            Set<Id> availEqipmentIds = new Set<Id>{TESTInit.equipments.get(0).Id,TESTInit.equipments.get(1).Id};
            Set<Id> returnedEqipmentIds = new Set<Id>();
            for (Sobject o : ext.resultItems) {
                returnedEqipmentIds.add(o.Id);                  
            }                        
            System.assert(!(returnedEqipmentIds.contains(TESTInit.equipments.get(1).Id)),'should not contain the 2nd euqipment, because the material is filtered');
            
            
            
            List<List<String>> filters = ext.getFilterCriteria();            
            System.assertEquals(filters.get(0).get(1), TESTInit.materials.get(0).Name,'Filter should contain Material');
            
            
            
            ext = runQueryTest('Equipment__c', 'eq', '{ "material__c" : "' + TESTInit.materials.get(0).Id + '"}');
            returnedEqipmentIds = new Set<Id>();
            for (Sobject o : ext.resultItems) {
                returnedEqipmentIds.add(o.Id);                  
            }                        
            System.assert(!(returnedEqipmentIds.contains(TESTInit.equipments.get(1).Id)),'should not contain the 2nd euqipment, because the material is filtered');
            
        }
        catch (System.Exception e)
        {
            System.debug('**** Exception occured in test method filterTest4: ' + e);
            System.assert(false);
        }        
    }
/*
    static testMethod void filterTest5() {
        try
        {
            //Query with no filtered customer and a query, that is too short,  should give a warning            
            
            MedicalRecordLookupController ext = runQueryTest('Professional__c', 'a*', '{ "recordtypeid" : "' + SystemId__c.getInstance('RecordType_ActivationReport').Value__c + '"}');
            System.assert(ApexPages.hasMessages());
        }
        catch (System.Exception e)
        {
            System.debug('**** Exception occured in test method filterTest5: ' + e);
            System.assert(false);
        }        
    }

    static testMethod void filterTest6() {
        try
        {
            //Query with no filtered customer and an empty query should give a warning          
            MedicalRecordLookupController ext = runQueryTest('Professional__c', '', '{ "recordtypeid" : "' + SystemId__c.getInstance('RecordType_ActivationReport').Value__c + '"}');
            System.assert(ApexPages.hasMessages());
        }
        catch (System.Exception e)
        {
            System.debug('**** Exception occured in test method filterTest6: ' + e);
            System.assert(false);
        }        
    }
*/


    static testMethod void filterTest10() {
        try
        {        	        	
            //Query with no filtered material and a query, that is too short,  should give a warning            
            MedicalRecordLookupController ext = runDetailSearch('Patient__c', '{}', new Patient__c(LastName__c = 'Testlas*'));
            
            Set<Id> returnedIds = new Set<Id>();
            for (Sobject o : ext.resultItems) {
                returnedIds.add(o.Id);                  
            } 
            System.debug(returnedIds);
            System.assert((returnedIds.contains(TESTInit.patients.get(0).Id)),'search should contain the 1st patient');
            
        }
        catch (System.Exception e)
        {
            System.debug('**** Exception occured in test method filterTest10: ' + e);
            System.assert(false);
        }        
    }

    static testMethod void resultDisplayTest() {
        try
        {
            //Query with no filtered material and a query, that is too short,  should give a warning            
            MedicalRecordLookupController ext = runDetailSearch('Patient__c', '{}', new Patient__c(LastName__c = 'Resul*'));
            
            Set<Id> returnedIds = new Set<Id>();
            for (Sobject o : ext.resultItems) {
                returnedIds.add(o.Id);                  
            } 
            System.debug(returnedIds);
            
            ext.getResultFieldList();
            System.assertEquals(ext.pageNumber , 1, 'Result should have found records and resulttable has pagenumer 1');            
            System.assertEquals(ext.totalPageNumber > 1 , true, 'Result should have found > 5 records and resulttable has totalPageNumber >  1');
            ext.resultNextPage();
            System.assertEquals(ext.pageNumber , 2, 'not pagenumer 2');            
            ext.resultPreviousPage();
            System.assertEquals(ext.pageNumber , 1, 'not pagenumer 1');            
        }
        catch (System.Exception e)
        {
            System.debug('**** Exception occured in test method filterTest10: ' + e);
            System.assert(false);
        }        
    }
}