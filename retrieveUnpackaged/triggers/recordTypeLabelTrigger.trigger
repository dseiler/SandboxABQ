trigger recordTypeLabelTrigger on Contact (before insert, before update) {
	
	Map<Id, RecordType> recordTypeNames = new Map<Id, RecordType>([Select Id, Name from RecordType where SobjectType = 'Contact']);
	
	for (Contact c: Trigger.new)
	{
		c.RecordTypeLabel__c = recordTypeNames.get(c.RecordTypeId).Name;
		//c.RecordTypeLabel__c = Schema.Sobjecttype.Contact.getRecordTypeInfosById(c.RecordTypeId).getName();
	}

}