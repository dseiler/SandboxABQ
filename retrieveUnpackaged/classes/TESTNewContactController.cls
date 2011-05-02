/**
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TESTNewContactController
{        
	static {
		//Make sure that TESTInit static constructor is executed before starting Tests
		TESTInit.init();    	
    }
    
    static testMethod void createNewContactBasedOnCustomSetting()
    {
        try
        {
            System.assert(TESTInit.masterAccountId != null, 'Can not run test createNewContactBasedOnCustomSetting without corresponding custom setting.');
            
            PageReference ref = Page.NewContact;
            Test.setCurrentPage(ref);
            //ApexPages.currentPage().getParameters().put('id', genId);
            
            Apexpages.Standardcontroller std = new Apexpages.Standardcontroller(new Contact());
            NewContactController ext = new NewContactController(std);
            
            PageReference result = ext.newContactAction();
            
            System.assertEquals(result.getUrl(), new PageReference('/003/e?nooverride=1&con4_lkid=' + TESTInit.masterAccountId).getUrl() + '&retURL=%2F003%2Fo', 'Wrong result URL');
            
        }
        catch (System.Exception e)
        {
            System.debug('**** Exception occured in test method createNewContactBasedOnCustomSetting: ' + e);
            System.assert(false);
        }
    }
    
    static testMethod void createNewContactWithoutCustomSetting()
    {
        try
        {
            PageReference ref = Page.NewContact;
            Test.setCurrentPage(ref);
            //ApexPages.currentPage().getParameters().put('id', genId);
            
            Apexpages.Standardcontroller std = new Apexpages.Standardcontroller(new Contact());
            NewContactController ext = new NewContactController(std);
            
            ext.masterAccountId = null;
            PageReference result = ext.newContactAction();
            
            System.assertEquals(result.getUrl(), new PageReference('/003/e?nooverride=1&con4=MASTER_ACCOUNT').getUrl() + '&retURL=%2F003%2Fo', 'Wrong result URL');
        }
        catch (System.Exception e)
        {
            System.debug('**** Exception occured in test method createNewContactWithoutCustomSetting: ' + e);
            System.assert(false);
        }
    }

}