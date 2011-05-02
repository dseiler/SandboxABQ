public class NewContactController
{
    public String masterAccountId;
    
    public NewContactController(ApexPages.StandardController controller)
    {
        try
        {
            masterAccountId = SystemId__c.getInstance('MASTER_ACCOUNT').Value__c;
        }
        catch (Exception e)
        {
            masterAccountId = null;
        }
    }
    
    public PageReference newContactAction()
    {
        if (masterAccountId != null)
        {
            system.debug('******** Found Custom Setting for Master Account: ' + masterAccountId);
            return new PageReference('/003/e?nooverride=1&retURL=%2F003%2Fo&con4_lkid=' + masterAccountId);
        }
        else
        {
            system.debug('******** Custom Setting for Master Account NOT found, using text MASTER_ACCOUNT instead');
            return new PageReference('/003/e?nooverride=1&retURL=%2F003%2Fo&con4=MASTER_ACCOUNT');
        }
    }
}