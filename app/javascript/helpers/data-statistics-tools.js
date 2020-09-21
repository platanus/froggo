/* eslint-disable no-magic-numbers*/
export function mean(dataArray) {
  const sumValue = dataArray.reduce((a, b) => a + b, 0);
  const meanValue = Math.floor(sumValue / dataArray.length);

  return meanValue;
}

export function standardDeviation(dataArray) {
  const thisMean = mean(dataArray);
  const variance = dataArray.reduce((acc, value) => acc + ((value - thisMean) ** 2), 0) / dataArray.length;

  return Math.sqrt(variance);
}
