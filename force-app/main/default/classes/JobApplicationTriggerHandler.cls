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

}    