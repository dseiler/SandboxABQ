public class TESTInit {
    public static List<Material__c> materials = new List<Material__c>();
    public static List<Equipment__c> equipments = new List<Equipment__c>();
    public static List<Account> accounts = new List<Account>();
    public static List<Patient__c> patients = new List<Patient__c>();
    public static string masterAccountId;
    
    public static void init() {
    	System.debug( 'Patient count: ' + TESTInit.patients.size());    	
		System.debug( 'Accounts count: ' + TESTInit.accounts.size());    	
		System.debug( 'Equipments count: ' + TESTInit.equipments.size());    	
		System.debug( 'Materials count: ' + TESTInit.materials.size());    	
		System.debug( 'masterAccountId: ' + TESTInit.masterAccountId);    
    }
    
    static
    {
        // init data used for testing
        try
        {
        	masterAccountId = SystemId__c.getInstance('MASTER_ACCOUNT').Value__c;	
            materials.add(new Material__c(Name = 'MaterialName1'));             
            materials.add(new Material__c(Name = 'MaterialName2'));             
            insert materials;

            equipments.add(new Equipment__c(Name = 'EQ0', Material__c = materials.get(0).Id));              
            equipments.add(new Equipment__c(Name = 'EQ1', Material__c = materials.get(1).Id));              
            insert equipments;
            
            
            accounts.add(new Account(Name = 'Account1',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1'));               
            insert accounts;

            patients.add(new Patient__c(LastName__c = 'Testlastname',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               

            patients.add(new Patient__c(LastName__c = 'ResultScreenTest1',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               
            patients.add(new Patient__c(LastName__c = 'ResultScreenTest2',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               
            patients.add(new Patient__c(LastName__c = 'ResultScreenTest3',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               
            patients.add(new Patient__c(LastName__c = 'ResultScreenTest4',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               
            patients.add(new Patient__c(LastName__c = 'ResultScreenTest5',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               
            patients.add(new Patient__c(LastName__c = 'ResultScreenTest6',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               
            patients.add(new Patient__c(LastName__c = 'ResultScreenTest7',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               
            patients.add(new Patient__c(LastName__c = 'ResultScreenTest8',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               
            patients.add(new Patient__c(LastName__c = 'ResultScreenTest9',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               
            patients.add(new Patient__c(LastName__c = 'ResultScreenTest10',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               
            patients.add(new Patient__c(LastName__c = 'ResultScreenTest11',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               
            patients.add(new Patient__c(LastName__c = 'ResultScreenTest12',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               
            patients.add(new Patient__c(LastName__c = 'ResultScreenTest13',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               
            patients.add(new Patient__c(LastName__c = 'ResultScreenTest14',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               
            patients.add(new Patient__c(LastName__c = 'ResultScreenTest15',Street__c = 'Account Street1', HouseNumber__c = '47', City__c = 'AccountCity1', Inactive__c = false));               


            insert patients;
        }
        catch (Exception e)
        {
            System.debug('**** Exception occured in test initialization: ' + e);
            System.assert(false);
        }
    }   

}