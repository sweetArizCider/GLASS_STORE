const calendarDays = document.getElementById('calendarDays');
const calendarMonth = document.getElementById('calendarMonth');
const prevMonth = document.getElementById('prevMonth');
const nextMonth = document.getElementById('nextMonth');
const selectedDateInput = document.getElementById('selectedDateInput');
const dateForm = document.getElementById('dateForm');

let currentDate = new Date();
let selectedDate = null;

function renderCalendar(date) {
  calendarDays.innerHTML = '';
  const year = date.getFullYear();
  const month = date.getMonth();

  const firstDayOfMonth = new Date(year, month, 1).getDay();
  const daysInMonth = new Date(year, month + 1, 0).getDate();

  calendarMonth.textContent = date.toLocaleString('default', { month: 'long', year: 'numeric' });

  for (let i = 0; i < firstDayOfMonth; i++) {
    calendarDays.innerHTML += '<div></div>';
  }

  for (let i = 1; i <= daysInMonth; i++) {
    const day = document.createElement('div');
    day.classList.add('calendar-day');
    day.textContent = i;
    day.addEventListener('click', () => selectDate(new Date(year, month, i)));
    calendarDays.appendChild(day);
  }
}

function selectDate(date) {
  selectedDate = date;
  document.querySelectorAll('.calendar-day').forEach(day => {
    day.classList.remove('selected');
  });
  const dayElement = calendarDays.children[date.getDate() + new Date(date.getFullYear(), date.getMonth(), 1).getDay() - 1];
  dayElement.classList.add('selected');
  selectedDateInput.value = date.toISOString().split('T')[0];
}

prevMonth.addEventListener('click', () => {
  currentDate.setMonth(currentDate.getMonth() - 1);
  renderCalendar(currentDate);
});

nextMonth.addEventListener('click', () => {
  currentDate.setMonth(currentDate.getMonth() + 1);
  renderCalendar(currentDate);
});

renderCalendar(currentDate);