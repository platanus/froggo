function setDays(days, dayLabel) {
  if (days === 0) return '';

  return `${days} ${dayLabel}${days > 1 ? 's ' : ' '}`;
}

function setHours(hours, hourLabel) {
  if (hours === 0) return '';

  return `${hours} ${hourLabel}${hours > 1 ? 's ' : ' '}`;
}

function setMinutes(minutes, minuteLabel) {
  if (minutes === 0) return '';

  return `${minutes} ${minuteLabel}${minutes > 1 ? 's ' : ' '}`;
}

export default function timeFormatter(numberOfMinutes, dayLabel, hourLabel, minLabel) {
  const minutesInHour = 60;
  const hoursInDay = 24;
  const days = Math.floor(numberOfMinutes / (hoursInDay * minutesInHour));
  const hours = Math.floor((numberOfMinutes % (hoursInDay * minutesInHour)) / minutesInHour);
  const minutes = Math.floor((numberOfMinutes % (hoursInDay * minutesInHour)) % minutesInHour);

  return `${setDays(days, dayLabel)}${setHours(hours, hourLabel)}${setMinutes(minutes, minLabel)}` || `0 ${minLabel}s`;
}
