public with sharing class CloseStaleApplications_Batchable implements Database.Batchable<sObject>, Database.Stateful {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        //query for all job applications that are not closed or accepted and Follow Up date is older than 30 days ago
        return Database.getQueryLocator([
                                        SELECT Id, Status__c 
                                        FROM Job_Application__c 
                                        WHERE (Status__c != 'Closed' OR Status__c != 'Accepted') 
                                        AND Follow_up_date__c < LAST_N_DAYS: 31
                                        ]);
    }

    //close all job applications in the scope and update the notes field that the application was closed by an automated process
    public void execute(Database.BatchableContext bc, List<Job_Application__c> scope) {
        List<Job_Application__c> applicationsToUpdate = new List<Job_Application__c>();
        for(Job_Application__c app : scope){
            app.Status__c = 'Closed';
            app.Description__c = 'Closed by automated process';
            applicationsToUpdate.add(app);
        }
        System.debug(applicationsToUpdate);
        update applicationsToUpdate;

        //query for all tasks related to the job applications in the scope that are not closed, close them and add a note that the task was closed by an automated process
        List<Task> tasksToUpdate = [SELECT Id, Status FROM Task WHERE Job_Application__c IN :scope AND Status != 'Closed'];
        for(Task t : tasksToUpdate){
            t.Status = 'Closed';
            t.Description = 'Closed by automated process';
        }
        System.debug(tasksToUpdate);
        update tasksToUpdate;
    }

    public void finish(Database.BatchableContext bc) {

    }
}