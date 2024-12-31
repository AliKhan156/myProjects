public with sharing class taskController {
    @AuraEnabled(cacheable=true)
    public static List<Custom_Task__c> getTasks(String statusFilter, String priorityFilter) {
        String query = 'SELECT Name, Description__c, Status__c, Priority__c, Due_Date__c, Assigned_To__r.Name, Related_Account__r.Name FROM Custom_Task__c';
        
        if (!String.isBlank(statusFilter) || !String.isBlank(priorityFilter)) {
            query += ' WHERE ';
            List<String> filters = new List<String>();
            if (!String.isBlank(statusFilter)) {
                filters.add('Status__c = :statusFilter');
            }
            if (!String.isBlank(priorityFilter)) {
                filters.add('Priority__c = :priorityFilter');
            }
            query += String.join(filters, ' AND ');
        }

        return Database.query(query);
    }
}
