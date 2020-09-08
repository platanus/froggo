function setDays(days) {
  if (days === 0) return '';

  return `${days} dia${days > 1 ? 's ' : ' '}`;
}

function setHours(hours) {
  if (hours === 0) return '';

  return `${hours} hora${hours > 1 ? 's ' : ' '}`;
}

function setMinutes(minutes) {
  if (minutes === 0) return '';

  return `${minutes} minuto${minutes > 1 ? 's ' : ' '}`;
}

export default function timeFormatter(numberOfMinutes) {
  const minutesInHour = 60;
  const hoursInDay = 24;
  const days = Math.floor(numberOfMinutes / (hoursInDay * minutesInHour));
  const hours = Math.floor((numberOfMinutes % (hoursInDay * minutesInHour)) / minutesInHour);
  const minutes = Math.floor((numberOfMinutes % (hoursInDay * minutesInHour)) % minutesInHour);

  return `${setDays(days)}${setHours(hours)}${setMinutes(minutes)}` || '0 minutos';
}
