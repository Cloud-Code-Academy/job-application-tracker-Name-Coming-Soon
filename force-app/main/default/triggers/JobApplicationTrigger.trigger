trigger JobApplicationTrigger on Job_Application__c (before insert, after insert, 
                                                    before update, after update, 
                                                    before delete) {
    switch on trigger.operationType {
        when BEFORE_INSERT {
            JobApplicationTriggerHandler.createAppFollowUpDate(Trigger.new);
            }
        when AFTER_INSERT {
            JobApplicationTriggerHandler.createTaskFromStatus(Trigger.new, null);                       
        }
        when BEFORE_UPDATE {
            JobApplicationTriggerHandler.createTaskFromStatus(Trigger.new, Trigger.oldMap);             
        }
        when AFTER_UPDATE {
            // Do something 
        }
        when BEFORE_DELETE {
            // Do something
        }
    }
}
