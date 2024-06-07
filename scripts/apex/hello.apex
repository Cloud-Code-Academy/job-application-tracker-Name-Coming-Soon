// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);

Job_Interview__c job = new Job_Interview__c();
job.Name = 'Test1';
job.Interview_Date__c = Date.newInstance(2024, 20, 4);
insert job;

interviewEmail jobReminder = new interviewEmail();
String sch = '0 51 0 21 4 ?';
String jobID = System.schedule('Scheduled Interview', sch, jobReminder);