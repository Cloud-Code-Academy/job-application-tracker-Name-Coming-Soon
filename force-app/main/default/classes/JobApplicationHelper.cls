public with sharing class JobApplicationHelper {
    public JobApplicationHelper() {

    }

    public static Task createTaskForStatus(String status, Job_Application__c jobApplication) {
        Task newTask = new Task();
        newTask.ActivityDate = System.today().addDays(2);
        //newTask.Company__c = jobApplication.Company_Name__c;
        newTask.Job_Application__c = jobApplication.Id;
        newTask.Job__c = jobApplication.Job__c;
        newTask.OwnerId = jobApplication.Applicant__c;
        newTask.WhoId = jobApplication.Primary_Contact__c;

        
        switch on status {
            when 'Saved' {
                newTask.Subject = 'Ready to Apply';
                newTask.Description = 'Check if the job description aligns with your interests and values.\nReview the highlighted skills to see if the role is a good fit.\nResearch the company or role and mark your excitement level.';
                newTask.Priority = 'Normal';
            }
            when 'Applying' {
                newTask.Subject = 'Apply for the Job';
                newTask.Description = 'Find and research someone who works at the company and add them as a contact.\nSet up an informational interview to learn more about the role/company.\nIdentify potential referrals to help get your application on the top of the pile.\nCustomize your work achievements using the job description keywords.\nSubmit your application on the company website if possible.';
                newTask.Priority = 'Normal';
            }
            when 'Applied' {
                newTask.Subject = 'Follow up on Application';
                newTask.Description = 'Reach out to the hiring manager or recruiter.\nFollow up on your application via email weekly.\nContinue identifying and saving similar job opportunities.\nSet up weekly networking calls to explore similar companies/roles.';
                newTask.Priority = 'Normal';
            }
            when 'Interviewing' {
                newTask.Subject = 'Prepare for the Interview';
                newTask.Description = 'Prepare your blurb or “tell me about yourself” response.\nPractice answering behavioral interview questions.\nResearch the company and your interviewers.\nSet up your virtual interview space and test your tech. Send thank you emails within 24 hours.';
                newTask.Priority = 'High';
            }
            when 'Negotiating' {
                newTask.Subject = 'Evaluate and Negotiate the Offer';
                newTask.Description = 'Research your market value and know your numbers.\nPrepare your negotiation scripts.\nEvaluate your offer and decline or accept.';
                newTask.Priority = 'Normal';
            }
            when 'Accepted' {
                newTask.Subject = 'Plan for Onboarding';
                newTask.Description = 'Plan your resignation if applicable.\nTake some time to relax and recharge.\nPrepare for your first day of onboarding.';
                newTask.Priority = 'Normal';
            }
            when 'Closed' {
                newTask.Subject = 'On to the Next Opportunity';
                newTask.Description = 'Send a follow-up email thanking the interviewer and asking for feedback.\nReview your notes and reflect on areas of improvement.';
                newTask.Priority = 'Normal';
            }
        }  
        System.debug(newTask);
        return newTask;
    }
}