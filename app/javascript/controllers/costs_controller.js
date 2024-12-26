import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    setDateField(event) {
        const day = this.data.get("day")
        console.log(day);
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
        console.log(month);
        const startDateField = document.getElementById('q_date_gteq');
        const endDateField = document.getElementById('q_date_lteq');
        const today = new Date();
        let startDate, endDate;

        if (month === 'last-month') {
            const firstDayLastMonth = new Date(today.getFullYear(), today.getMonth() - 1, 1);
            const lastDayLastMonth = new Date(today.getFullYear(), today.getMonth() - 1, new Date(today.getFullYear(), today.getMonth(), 0).getDate());
            startDate = firstDayLastMonth.toISOString().split('T')[0];
            endDate = lastDayLastMonth.toISOString().split('T')[0];
        } else if (month === 'this-month') {
            const firstDayThisMonth = new Date(today.getFullYear(), today.getMonth(), 1);
            const lastDayThisMonth = new Date(today.getFullYear(), today.getMonth() + 1, 0);
            startDate = firstDayThisMonth.toISOString().split('T')[0];
            endDate = lastDayThisMonth.toISOString().split('T')[0];
        }

        startDateField.value = startDate;
        endDateField.value = endDate;
    }
}