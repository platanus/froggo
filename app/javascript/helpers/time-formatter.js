function setDays(days, resultString) {
  let newResultString = resultString;
  if (days !== 0) {
    newResultString += days > 1 ? `${days} dias ` : `${days} dia `;
  }

  return newResultString;
}

function setHours(hours, resultString) {
  let newResultString = resultString;
  if (hours !== 0) {
    newResultString += hours > 1 ? `${hours} horas ` : `${hours} hora `;
  }

  return newResultString;
}

function setMinutes(minutes, resultString) {
  let newResultString = resultString;
  if (minutes !== 0) {
    newResultString += minutes > 1 ? `${minutes} minutos ` : `${minutes} minuto `;
  }

  return newResultString;
}

export default function timeFormatter(numberOfMinutes) {
  const minutesInHour = 60;
  const hoursInDay = 24;
  const days = Math.floor(numberOfMinutes / (hoursInDay * minutesInHour));
  const hours = Math.floor((numberOfMinutes % (hoursInDay * minutesInHour)) / minutesInHour);
  const minutes = Math.floor((numberOfMinutes % (hoursInDay * minutesInHour)) % minutesInHour);
  let result = '';
  result = setDays(days, result);
  result = setHours(hours, result);
  result = setMinutes(minutes, result);

  return result;
}
