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
              labelString: this.$i18n.t('message.metrics.chartYLabel'),
            },
          }],
        },
        tooltips: {
          callbacks: {
            label: (tooltipItem, data) => {
              const value = tooltipItem.yLabel;
              const label = timeFormatter(
                value,
                this.$i18n.t('message.time.day'),
                this.$i18n.t('message.time.hour'),
                this.$i18n.t('message.time.minute'),
              );

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
