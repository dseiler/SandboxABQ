trigger setMasterAccountTrigger on Contact (before insert)
{
    //List<Account> masterAccounts = [Select Id from Account where Name = 'MASTER_ACCOUNT' limit 1];
    
    Id masterAccountId = SystemId__c.getInstance('MASTER_ACCOUNT').Value__c;
    
    //if(masterAccounts.size() > 0)
    //{
        for (Contact c: Trigger.new)
        {
            //c.AccountId = masterAccounts[0].Id;
            c.AccountId = masterAccountId;
        }
    //}
}