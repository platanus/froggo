export default function colorFromScore(score, noColor = 'bg-gray-500') {
  /* eslint-disable no-magic-numbers*/
  if (score === -1.0) return noColor;

  if (score <= 0.25) return 'bg-teal-500';
  if (score <= 0.5) return 'bg-teal-300';
  if (score <= 0.75) return 'bg-teal-100';
  if (score <= 1) return 'bg-yellow-300';
  if (score <= 1.25) return 'bg-yellow-200';
  if (score <= 1.5) return 'bg-red-100';
  if (score <= 1.75) return 'bg-red-300';

  return 'bg-red-500';
}
