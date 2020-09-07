<template>
  <div>
    <metrics-summary
      :metrics-summary="prepareSummary()"
    />
    <div class="profile-metrics">
      <h3>Métricas de tiempo</h3>
      <metrics-chart
        :pr-id-array="prIdArray"
        :datasets="prepareDatasets"
      />
    </div>
  </div>
</template>

<script>
import MetricsChart from './metrics-chart.vue';
import MetricsSummary from './metrics-summary.vue';
import timeFormatter from '../../helpers/time-formatter.js';

export default {
  props: {
    pullRequestInformation: {
      default: null,
      type: Object,
    },
  },
  components: {
    MetricsChart,
    MetricsSummary,
  },
  data() {
    return {
      colors: [
        'rgb(255, 99, 132)',
        'rgb(255, 206, 86)',
        'rgb(75, 192, 192)',
        'rgb(153, 102, 255)',
      ],
      AssignmentTimeIndex: 0,
      ResponseTimeIndex: 1,
      ApprovalTimeIndex: 2,
      MergeTimeIndex: 3,
    };
  },
  computed: {
    prIdArray() {
      return Object.values(this.pullRequestInformation).map((pullRequest) => {
        const repository = pullRequest.repository;
        const prNumber = pullRequest.pr_number;

        return `${repository} #${prNumber}`;
      });
    },
    getAssignmentTime() {
      // Entrega la metrica de tiempo entre creación y asignación (a un revisor) de pull request
      return Object.values(this.pullRequestInformation).map((pullRequest) => {
        const pullRequestCreatedAt = new Date(pullRequest.pr_created_at);
        const pullRequestAssignment = new Date(pullRequest.review_request_created_at);
        const millisecondsToMinutes = 60000;
        const timeDelta = Math.floor((pullRequestAssignment - pullRequestCreatedAt) / millisecondsToMinutes);

        return timeDelta;
      });
    },
    getResponseTime() {
      // Entrega la metrica de tiempo entre asignación (a un revisor) y respuesta (del primer revisor) de pull request
      return Object.values(this.pullRequestInformation).map((pullRequest) => {
        const pullRequestAssignment = new Date(pullRequest.review_request_created_at);
        const pullRequestResponse = new Date(pullRequest.first_response);
        const millisecondsToMinutes = 60000;
        const timeDelta = Math.floor((pullRequestResponse - pullRequestAssignment) / millisecondsToMinutes);

        return timeDelta;
      });
    },
    getApprovalTime() {
      // Entrega la metrica de tiempo entre respuesta (del primer revisor)
      // y aprobación (del último revisor) de pull request
      // en caso de no existir last_approval retorna 0
      return Object.values(this.pullRequestInformation).map((pullRequest) => {
        if (!('last_approval' in pullRequest)) {
          return 0;
        }
        const pullRequestResponse = new Date(pullRequest.first_response);
        const pullRequestApproval = new Date(pullRequest.last_approval);
        const millisecondsToMinutes = 60000;
        const timeDelta = Math.floor((pullRequestApproval - pullRequestResponse) / millisecondsToMinutes);

        return timeDelta;
      });
    },
    getMergeTime() {
      // Entrega la metrica de tiempo entre aprobación (del último revisor) y merge de pull request
      // en caso de no existir last_approval retorna el tiempo entre primera respuesta y merge
      return Object.values(this.pullRequestInformation).map((pullRequest) => {
        const pullRequestMerge = new Date(pullRequest.pr_merget_at);
        const milisecondsToMinutes = 60000;
        if (!('last_approval' in pullRequest)) {
          const pullRequestResponse = new Date(pullRequest.first_response);
          const timeDelta = Math.floor((pullRequestMerge - pullRequestResponse) / milisecondsToMinutes);

          return timeDelta;
        }
        const pullRequestApproval = new Date(pullRequest.last_approval);
        const timeDelta = Math.floor((pullRequestMerge - pullRequestApproval) / milisecondsToMinutes);

        return timeDelta;
      });
    },
    prepareDatasets() {
      const datasets = [];
      datasets.push({
        label: 'Tiempo entre creación y asignación de pull request',
        data: this.getAssignmentTime,
        color: this.colors[this.AssignmentTimeIndex],
      });
      datasets.push({
        label: 'Tiempo entre asignación y primera respuesta de pull request',
        data: this.getResponseTime,
        color: this.colors[this.ResponseTimeIndex],
      });
      datasets.push({
        label: 'Tiempo entre primera respuesta y aprobación de pull request',
        data: this.getApprovalTime,
        color: this.colors[this.ApprovalTimeIndex],
      });
      datasets.push({
        label: 'Tiempo entre aprobación y merge de pull request',
        data: this.getMergeTime,
        color: this.colors[this.MergeTimeIndex],
      });

      return datasets;
    },
  },
  methods: {
    getMeanTime(dataArray) {
      const sumValue = dataArray.reduce((a, b) => a + b, 0);
      const meanValue = Math.floor(sumValue / dataArray.length);
      let label = timeFormatter(meanValue);
      if (label === '') {
        label = '0 minutos';
      }

      return label;
    },
    prepareSummary() {
      return [{
        textTop: 'creación y asignación',
        textBottom: 'de pull requests',
        value: this.getMeanTime(this.getAssignmentTime),
      }, {
        textTop: 'asignación y respuesta',
        textBottom: 'de pull requests',
        value: this.getMeanTime(this.getResponseTime),
      }, {
        textTop: 'respuesta y aprobación',
        textBottom: 'de pull requests',
        value: this.getMeanTime(this.getApprovalTime),
      }, {
        textTop: 'aprobación y merge',
        textBottom: 'de pull requests',
        value: this.getMeanTime(this.getMergeTime),
      }];
    },
  },
};
</script>
