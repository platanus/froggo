<script>
import { Line } from 'vue-chartjs';
import timeFormatter from '../../helpers/time-formatter.js';

export default {
  extends: Line,
  props: {
    prIdArray: {
      default: () => [],
      type: Array,
    },
    datasets: {
      default: () => [],
      type: Array,
    },
  },
  computed: {
    options() {
      return {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          yAxes: [{
            scaleLabel: {
              display: true,
              labelString: 'minutos',
            },
          }],
        },
        tooltips: {
          callbacks: {
            label: (tooltipItem, data) => {
              const value = tooltipItem.yLabel;
              const label = timeFormatter(value);

              return [data.datasets[tooltipItem.datasetIndex].label, label];
            },
          },
        },
      };
    },
    data() {
      const data = {
        labels: this.prIdArray,
        datasets: [],
      };
      this.datasets.forEach((currentMetricData) => {
        data.datasets.push({
          label: currentMetricData.label,
          data: currentMetricData.data,
          fill: false,
          borderColor: currentMetricData.color,
          pointBackgroundColor: currentMetricData.color,
          pointRadius: 4,
        });
      });

      return data;
    },
  },
  mounted() {
    this.renderChart(this.data, this.options);
  },
};
</script>
