import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    setDateField(event) {
        const day = this.data.get("day")
        const dateField = document.getElementById('cost_date');
        const nextField = document.getElementById('cost_amount');
        const today = new Date();
        let date;
        if (day === 'today') {
            date = today.toISOString().split('T')[0];
        } else if (day === 'yesterday') {
            const yesterday = new Date(today);
            yesterday.setDate(today.getDate() - 1);
            date = yesterday.toISOString().split('T')[0];
        }

        dateField.value = date;

        if (nextField) {
            nextField.focus();
        }
    }

    setMonthField(event) {
        const month = this.data.get("month");
        const startDateField = document.getElementById('q_date_gteq');
        const endDateField = document.getElementById('q_date_lteq');
        const today = new Date();
        let startDate, endDate;

        if (month === 'last-month') {
            const startOfLastMonth = new Date(today.getFullYear(), today.getMonth() - 1, 2);
            const endOfLastMonth = new Date(today.getFullYear(), today.getMonth(), 1);

            startDate = startOfLastMonth.toISOString().slice(0, 10);
            endDate = endOfLastMonth.toISOString().slice(0, 10);

        } else if (month === 'this-month') {
            const startOfThisMonth = new Date(today.getFullYear(), today.getMonth(), 2);
            const endOfThisMonth = new Date(today.getFullYear(), today.getMonth() + 1, 1);

            startDate = startOfThisMonth.toISOString().slice(0, 10);
            endDate = endOfThisMonth.toISOString().slice(0, 10);
        }

        startDateField.value = startDate;
        endDateField.value = endDate;
    }

}