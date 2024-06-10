trigger InterviewEmailTrigger on Job_Interview__c (after insert, after update) {
	switch on trigger.operationType {
		when BEFORE_INSERT {
		}
		when AFTER_INSERT {
			InterviewEmailHelper.schdInterviewReminder(trigger.new);
		}
		when BEFORE_UPDATE {
		}
		when AFTER_UPDATE {
            InterviewEmailHelper.schdInterviewReminder(trigger.new);
		}
		when BEFORE_DELETE {
		}
	}

}