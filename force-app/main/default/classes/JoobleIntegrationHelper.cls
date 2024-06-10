public with sharing class JoobleIntegrationHelper {
    public static Integer extractSalaries(String range) {
        if (String.isBlank(range)) {
            return 0;
        }
        Boolean isHourly, isMonthly;
        isHourly = range.contains('hour');
        isMonthly = range.contains('month');
        range = range.trim(); // Trim the input string
        range = range.remove(',');
        Integer salary;
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
                salary = salary * 1000;//assuming yearly salary is represented as 125k
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
    
    public static Integer findFirstNumericIndex(String str) {
        for (Integer i = 0; i < str.length(); i++) {
            if (str.substring(i, i + 1).isNumeric()) {
                return i;
            }
        }
        return -1; // No numeric character found
    }
}