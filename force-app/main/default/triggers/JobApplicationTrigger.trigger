trigger JobApplicationTrigger on Job_Application__c (before insert, after insert, before update, after update, before delete) {
	switch on trigger.operationType {
		when BEFORE_INSERT {
			// Do something
		}
		when AFTER_INSERT {
			JobApplicationTriggerHandler.createTaskFromStatus(trigger.new);
		}
		when BEFORE_UPDATE {
			// Do something	
			JobApplicationTriggerHandler.createTaskFromStatus(trigger.new);	
		}
		when AFTER_UPDATE {
			// Do something	
		}
		when BEFORE_DELETE {
			// Do something
		}
	}
}