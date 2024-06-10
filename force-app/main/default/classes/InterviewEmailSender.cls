/**
 * Send email reminder for an interview scheduled for tomorrow
 */
public with sharing class InterviewEmailSender {
    public static void sendMail(List<Job_Interview__c> upcomingInterviews) {
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        String userTimeZone = UserInfo.getTimeZone().getID();
        String formattedTime;
        DateTime IntDateTime;

        /**
         * Iterate over all interviews and send an email for each interview if a valid
         * email is present
         */
        for (Job_Interview__c interview : upcomingInterviews) {
            IntDateTime = DateTime.newInstance(Date.today(), interview.Interview_Time__c);
            // Format the DateTime object to get the time in the user's local time zone
            formattedTime = IntDateTime.format('h:mm a', userTimeZone);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if (String.isBlank(interview.Job_Application__r.Applicant__r.Email)) {
                    continue;
            }

            List <String> toAddr = new List<String> ();
            mail.setSubject('Upcoming Interview Reminder');
            mail.setPlainTextBody('Dear ' + interview.Job_Application__r.Applicant__r.Name+ ',\n\n' +
                                  'This is to remind you of the upcoming interview scheduled for tomorrow with ' + 
                                   interview.Job_Application__r.Job__r.Company_Name__c + ' at ' + 
                                   + formattedTime +
                                   ' for the ' + 
                                   interview.Job_Application__r.Job__r.Title__c + ' position.' +
                                   '\n\nThank you.');
            
            //mail.setSaveAsActivity(false);
            toAddr.add(interview.Job_Application__r.Applicant__r.Email);
            mail.setToAddresses(toAddr);
            emailMessages.add(mail);
        }
        Messaging.sendEmail(emailMessages);
    }

    public static void EmailSender() {
        List<String> toaddress = new List <String> ();        
        Date tomorrow = Date.today().addDays(1);

        //fetch all interviews for tomorrow
        List<Job_Interview__c> upcomingInterviews = [SELECT Id, Interview_Date__c, Name,
                                                    Interview_Time__c,
                                                    Job_Application__r.Job__r.Company_Name__c,
                                                    Job_Application__r.Job__r.Title__c,
                                                    Job_Application__r.Applicant__r.Name,
                                                    Job_Application__r.Applicant__r.Email
                                                    FROM Job_Interview__c WHERE Interview_Date__c =:tomorrow];
        sendMail(upcomingInterviews);
    }
}