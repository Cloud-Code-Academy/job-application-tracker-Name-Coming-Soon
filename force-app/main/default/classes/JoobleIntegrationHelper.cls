public with sharing class JoobleIntegrationHelper {
    /**
     * calculate average salary.
     * salary can be a hourly/monthly/annual non-range or a 
     * range in the form of:
     * x - y per hour
     * x - y per month
     * x - y (annual)
     */
    public Integer extractSalaries(String range) {
        if (String.isBlank(range)) {
            return 0;
        } 
        Boolean isHourly, isMonthly;
        isHourly = range.contains('hour');
        isMonthly = range.contains('month');
        range = range.trim(); // Trim the input string
        range = range.remove(','); //remove commas, so salary is a continuous string
        Integer salary;

        /**
         * Extract both numbers from the range string. We look for continuous
         * digits in the String
         */
        if (range.contains('-')) {
            Integer startIndex = findFirstNumericIndex(range);
            Integer endIndex = startIndex;
            Integer firstNumber = 0;
            while (endIndex < range.length() && range.substring(endIndex, endIndex + 1).isNumeric()) {
                endIndex++;
            }
            firstNumber = Integer.valueOf(range.substring(startIndex, endIndex));
    
            String remainingString = range.substring(endIndex + 1);
            Integer secondStartIndex = findFirstNumericIndex(remainingString);
            Integer secondEndIndex = secondStartIndex;

            Integer secondNumber = 0;
            while (secondEndIndex < remainingString.length() && remainingString.substring(secondEndIndex, secondEndIndex + 1).isNumeric()) {
                secondEndIndex++;
            }
            secondNumber = Integer.valueOf(remainingString.substring(secondStartIndex, secondEndIndex));
            salary = (firstNumber + secondNumber)/2;
            if (isHourly) {
                salary = salary * 40 * 52;
            } else if (isMonthly) {
                salary = salary * 12;
            } else {
                salary = salary * 1000;//assuming yearly salary is represented as 125k, for example
            }
            return salary;
        } else {
            Integer startIndex = findFirstNumericIndex(range);
            Integer endIndex = startIndex;
            Integer singleNumber = 0;
            while (endIndex < range.length() && range.substring(endIndex, endIndex + 1).isNumeric()) {
                endIndex++;
            }
            singleNumber = Integer.valueOf(range.substring(startIndex, endIndex));
            if (isHourly) {
                singleNumber = singleNumber * 40 * 52;
            } else if (isMonthly) {
                singleNumber = singleNumber * 12;
            } else {
                singleNumber = singleNumber * 1000;
            }
            return singleNumber;
        }
    }
    
    //get the index of the first number
    public Integer findFirstNumericIndex(String str) {
        for (Integer i = 0; i < str.length(); i++) {
            if (str.substring(i, i + 1).isNumeric()) {
                return i;
            }
        }
        return -1; // No numeric character found
    }

    public Job__c extractJobfields(Map<String, Object> jobMap) {
        Job__c job = new Job__c();
        String salary;

        job.Title__c = (String) jobMap.get('title');
        job.Location__c = (String) jobMap.get('location');
        job.Link_to_Listing__c =(String) jobMap.get('link');
        job.Company_Name__c = (String) jobMap.get('company');
        salary = (String) jobMap.get('salary');
        job.Salary__c = extractSalaries(salary);

        if (String.isBlank(job.Company_Name__c)) {
            job.Name = job.Title__c;
        } else {
            job.Name = job.Title__c + ', ' + job.Company_Name__c;
        }
        job.Name = job.Name.abbreviate(80);
        job.Source__c = (String) jobMap.get('source');

        return job;
    }

    //parse Json Response from endpoint and return a list of jobs
    public List <Job__c> extractJobs(String jsonResponse) {
        Map<String, Object> jsonResponseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
        List<Object> jobList = (List<Object>) jsonResponseMap.get('jobs');
        List <Job__c> listOfJobs = new List <Job__c>();

        for(Object jobi: jobList) {
            Map<String, Object> jobMap  = (Map<String, Object>) jobi;
            Job__c job = extractJobfields(jobMap);
            listOfJobs.add(job);
        }
        return listOfJobs;
    }
}