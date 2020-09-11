<template>
  <div>
    <metrics-summary
      :metrics-summary="prepareSummary()"
    />
    <div class="profile-metrics">
      <h3>{{ $i18n.t('message.metrics.metricsTitle') }}</h3>
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
      colors: {
        AssignmentTimeColor: 'rgb(255, 99, 132)',
        ResponseTimeColor: 'rgb(255, 206, 86)',
        ApprovalTimeColor: 'rgb(75, 192, 192)',
        MergeTimeColor: 'rgb(153, 102, 255)',
      },
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
    creationToAssignmentTime() {
      return Object.values(this.pullRequestInformation).map((pullRequest) => {
        const pullRequestCreatedAt = new Date(pullRequest.pr_created_at);
        const pullRequestAssignment = new Date(pullRequest.review_request_created_at);
        const millisecondsToMinutes = 60000;
        const timeDelta = Math.floor((pullRequestAssignment - pullRequestCreatedAt) / millisecondsToMinutes);

        return timeDelta;
      });
    },
    assignmentToResponseTime() {
      return Object.values(this.pullRequestInformation).map((pullRequest) => {
        const pullRequestAssignment = new Date(pullRequest.review_request_created_at);
        const pullRequestResponse = new Date(pullRequest.first_response);
        const millisecondsToMinutes = 60000;
        const timeDelta = Math.floor((pullRequestResponse - pullRequestAssignment) / millisecondsToMinutes);

        return timeDelta;
      });
    },
    responseToApprovalTime() {
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
    approvalToMergeTime() {
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
        label: this.$i18n.t('message.metrics.creationToAssignmentTimeLabel'),
        data: this.creationToAssignmentTime,
        color: this.colors.AssignmentTimeColor,
      });
      datasets.push({
        label: this.$i18n.t('message.metrics.assignmentToResponseTimeLabel'),
        data: this.assignmentToResponseTime,
        color: this.colors.ResponseTimeColor,
      });
      datasets.push({
        label: this.$i18n.t('message.metrics.responseToApprovalTimeLabel'),
        data: this.responseToApprovalTime,
        color: this.colors.ApprovalTimeColor,
      });
      datasets.push({
        label: this.$i18n.t('message.metrics.approvalToMergeTimeLabel'),
        data: this.approvalToMergeTime,
        color: this.colors.MergeTimeColor,
      });

      return datasets;
    },
  },
  methods: {
    getMeanTime(dataArray) {
      const sumValue = dataArray.reduce((a, b) => a + b, 0);
      const meanValue = Math.floor(sumValue / dataArray.length);

      return timeFormatter(
        meanValue,
        this.$i18n.t('message.time.day'),
        this.$i18n.t('message.time.hour'),
        this.$i18n.t('message.time.minute'),
      );
    },
    prepareSummary() {
      return [{
        textTop: this.$i18n.t('message.metrics.topCreationToAssignmentSummaryText'),
        textBottom: this.$i18n.t('message.metrics.bottomSummaryText'),
        value: this.getMeanTime(this.creationToAssignmentTime),
      }, {
        textTop: this.$i18n.t('message.metrics.topAssignmentToResponseSummaryText'),
        textBottom: this.$i18n.t('message.metrics.bottomSummaryText'),
        value: this.getMeanTime(this.assignmentToResponseTime),
      }, {
        textTop: this.$i18n.t('message.metrics.topResponseToApprovalSummaryText'),
        textBottom: this.$i18n.t('message.metrics.bottomSummaryText'),
        value: this.getMeanTime(this.responseToApprovalTime),
      }, {
        textTop: this.$i18n.t('message.metrics.topApprovalToMergeSummaryText'),
        textBottom: this.$i18n.t('message.metrics.bottomSummaryText'),
        value: this.getMeanTime(this.approvalToMergeTime),
      }];
    },
  },
};
</script>
