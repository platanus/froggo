export default function colorFromScore(score, noColor = 'gray-500') {
  /* eslint-disable no-magic-numbers*/
  if (score === -1.0) return noColor;

  if (score <= 0.25) return 'teal-500';
  if (score <= 0.5) return 'teal-300';
  if (score <= 0.75) return 'teal-100';
  if (score <= 1) return 'yellow-300';
  if (score <= 1.25) return 'yellow-200';
  if (score <= 1.5) return 'red-100';
  if (score <= 1.75) return 'red-300';

  return 'red-500';
}
