public with sharing class JobApplicationTriggerHandler {

    //create task based on status of App
    public static void createTaskFromStatus(List<Job_Application__c> newJobApps, Map<Id, Job_Application__c> oldJobAppsMap) {

    List<Task> tasksToInsert = new List<Task>();

        for (Job_Application__c jobApplication : newJobApps) {
            //check if the record is being inserted
            if (jobApplication.Id == null) {
                if (jobApplication.Status__c != null) {
                    Task newTask = JobApplicationHelper.createTaskForStatus(jobApplication.Status__c, jobApplication);
                    tasksToInsert.add(newTask);
                }
            } else if (oldJobAppsMap != null) {
                //check if the status has changed
                Job_Application__c oldJobApp = oldJobAppsMap.get(jobApplication.Id);
                if (oldJobApp != null && oldJobApp.Status__c != jobApplication.Status__c) {
                    Task newTask = JobApplicationHelper.createTaskForStatus(jobApplication.Status__c, jobApplication);
                    tasksToInsert.add(newTask);
                }
            }    
        }
        
        insert tasksToInsert;
        System.debug(tasksToInsert);
    }
    
    //set Follow-up date on Job App 30-days out. Helps with cleanup of 'stale' job apps.
    public static void createAppFollowUpDate (List<Job_Application__c> jobApplications){
        for (Job_Application__c jobAppl : jobApplications) {
            try {
            Date today = Date.today();
            Date followUpDate = today.addDays(30);
            jobAppl.Follow_up_date__c = followUpDate;
            } catch (Exception e) {
                System.debug('Error updating Follow_up_date__c: ' + e.getMessage());
            }	
        }	
    }
}
