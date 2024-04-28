public with sharing class JobApplicationTriggerHandler {
    
    

    public static void createTaskFromStatus(List<Job_Application__c> jobApp) {
        List<Task> tasksToInsert = new List<Task>();

        for (Job_Application__c jobApplication : jobApp) {
            if (jobApplication.Status__c != null) {
                Task newTask = JobApplicationHelper.createTaskForStatus(jobApplication.Status__c, jobApplication);
                tasksToInsert.add(newTask);
            }
        }
        
        insert tasksToInsert;
    }
    
    public static void createAppFollowUpDate (List<Job_Application__c> jobApplications){
        for (Job_Application__c jobAppl : jobApplications) {
            try {
            Date today = Date.today();
            Date followUpDate = today.addDays(30);
            jobAppl.Follow_up_date__c = followUpDate;
            System.debug('Follow_up_date__c ' + followUpDate);
            } catch (Exception e) {
                System.debug('Error updating Follow_up_date__c: ' + e.getMessage());
       	    }	
        }	
    }
}