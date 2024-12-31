global class OverdueTaskScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Query overdue tasks
        List<Custom_Task__c> overdueTasks = [
            SELECT Id, Name, Assigned_To__r.Email, Assigned_To__r.Name, Due_Date__c, Priority__c
            FROM Custom_Task__c
            WHERE Due_Date__c <= :Date.today() AND Status__c != 'Completed'
        ];

        // Send reminders
        for (Custom_Task__c task : overdueTasks) {
            if (task.Assigned_To__r.Email != null) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { task.Assigned_To__r.Email });
                email.setSubject('Overdue Task Reminder: ' + task.Name);
                email.setPlainTextBody('Hello ' + task.Assigned_To__r.Name + ',\n\n'
                    + 'The following task is overdue:\n'
                    + '- Task Name: ' + task.Name + '\n'
                    + '- Due Date: ' + task.Due_Date__c + '\n'
                    + '- Priority: ' + task.Priority__c + '\n\n'
                    + 'Please take the necessary actions.\n\n'
                    + 'Regards,\n'
                    + 'Task Management System');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            }
        }
    }
}
