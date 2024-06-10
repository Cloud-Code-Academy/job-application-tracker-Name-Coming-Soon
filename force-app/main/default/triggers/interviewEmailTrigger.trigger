trigger InterviewEmailTrigger on Job_Interview__c (after insert, after update) {
	switch on trigger.operationType {
		when BEFORE_INSERT {
		}
		when AFTER_INSERT {
			InterviewEmailTriggerHelper.schdInterviewReminder(trigger.new);
		}
		when BEFORE_UPDATE {
		}
		when AFTER_UPDATE {
            InterviewEmailTriggerHelper.schdInterviewReminder(trigger.new);
		}
		when BEFORE_DELETE {
		}
	}

}