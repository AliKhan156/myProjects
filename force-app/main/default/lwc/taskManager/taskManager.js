import { LightningElement, track, wire } from 'lwc';
import getTasks from '@salesforce/apex/TaskController.getTasks';

export default class TaskManager extends LightningElement {
    @track tasks = [];
    @track statusFilter = '';
    @track priorityFilter = '';

    statusOptions = [
        { label: 'All', value: '' },
        { label: 'Open', value: 'Open' },
        { label: 'In Progress', value: 'In Progress' },
        { label: 'Completed', value: 'Completed' },
        { label: 'Overdue', value: 'Overdue' },
    ];

    priorityOptions = [
        { label: 'All', value: '' },
        { label: 'Low', value: 'Low' },
        { label: 'Medium', value: 'Medium' },
        { label: 'High', value: 'High' },
    ];

    @wire(getTasks, { statusFilter: '$statusFilter', priorityFilter: '$priorityFilter' })
    wiredTasks({ error, data }) {
        if (data) {
            this.tasks = data;
        } else if (error) {
            console.error(error);
        }
    }

    handleStatusChange(event) {
        this.statusFilter = event.target.value;
    }

    handlePriorityChange(event) {
        this.priorityFilter = event.target.value;
    }
}
