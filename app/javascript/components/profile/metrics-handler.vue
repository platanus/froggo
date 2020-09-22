<template>
  <div>
    <metrics-summary
      :metrics-summary="prepareSummary()"
    />
    <div class="profile-metrics">
      <h3>{{ $i18n.t('message.metrics.metricsTitle') }}</h3>
      <metrics-chart
        :pr-id-array="getDataLabels"
        :datasets="prepareDatasets"
      />
    </div>
  </div>
</template>

<script>
import MetricsChart from './metrics-chart.vue';
import MetricsSummary from './metrics-summary.vue';
import timeFormatter from '../../helpers/time-formatter.js';
import { mean, standardDeviation } from '../../helpers/data-statistics-tools.js';

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
        creationToAssignmentTimeColor: 'rgb(255, 99, 132)',
        assignmentToResponseTimeColor: 'rgb(255, 206, 86)',
        responseToApprovalTimeColor: 'rgb(75, 192, 192)',
        approvalToMergeTimeColor: 'rgb(153, 102, 255)',
      },
      trimmingFactor: 2,
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
        const timeDelta = Math.floor(Math.abs(pullRequestAssignment - pullRequestCreatedAt) / millisecondsToMinutes);

        return timeDelta;
      });
    },
    assignmentToResponseTime() {
      return Object.values(this.pullRequestInformation).map((pullRequest) => {
        const pullRequestAssignment = new Date(pullRequest.review_request_created_at);
        const pullRequestResponse = new Date(pullRequest.first_response);
        const millisecondsToMinutes = 60000;
        const timeDelta = Math.floor(Math.abs(pullRequestResponse - pullRequestAssignment) / millisecondsToMinutes);

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
        const timeDelta = Math.floor(Math.abs(pullRequestApproval - pullRequestResponse) / millisecondsToMinutes);

        return timeDelta;
      });
    },
    approvalToMergeTime() {
      return Object.values(this.pullRequestInformation).map((pullRequest) => {
        const pullRequestMerge = new Date(pullRequest.pr_merget_at);
        const milisecondsToMinutes = 60000;
        if (!('last_approval' in pullRequest)) {
          const pullRequestResponse = new Date(pullRequest.first_response);
          const timeDelta = Math.floor(Math.abs(pullRequestMerge - pullRequestResponse) / milisecondsToMinutes);

          return timeDelta;
        }
        const pullRequestApproval = new Date(pullRequest.last_approval);
        const timeDelta = Math.floor(Math.abs(pullRequestMerge - pullRequestApproval) / milisecondsToMinutes);

        return timeDelta;
      });
    },
    means() {
      return {
        creationToAssignmentTime: mean(this.creationToAssignmentTime),
        assignmentToResponseTime: mean(this.assignmentToResponseTime),
        responseToApprovalTime: mean(this.responseToApprovalTime),
        approvalToMergeTime: mean(this.approvalToMergeTime),
      };
    },
    standardDeviations() {
      return {
        creationToAssignmentTime: standardDeviation(this.creationToAssignmentTime),
        assignmentToResponseTime: standardDeviation(this.assignmentToResponseTime),
        responseToApprovalTime: standardDeviation(this.responseToApprovalTime),
        approvalToMergeTime: standardDeviation(this.approvalToMergeTime),
      };
    },
    unfilteredData() {
      const data = this.prIdArray.map((value, index) => ({
        label: value,
        creationToAssignmentTime: this.creationToAssignmentTime[index],
        assignmentToResponseTime: this.assignmentToResponseTime[index],
        responseToApprovalTime: this.responseToApprovalTime[index],
        approvalToMergeTime: this.approvalToMergeTime[index],
      }));

      return data;
    },
    getTrimmedData() {
      const trimmedData = this.unfilteredData.filter((currValue) => {
        if (['creationToAssignmentTime', 'assignmentToResponseTime', 'responseToApprovalTime', 'approvalToMergeTime']
          .every(key => currValue[key] === 0)) {
          return false;
        }

        return ['creationToAssignmentTime', 'assignmentToResponseTime', 'responseToApprovalTime', 'approvalToMergeTime']
          .every(key => (
            currValue[key] <= this.means[key] + this.trimmingFactor * this.standardDeviations[key]
          ));
      });

      return trimmedData;
    },
    getDataLabels() {
      return this.getTrimmedData.map((value) => value.label);
    },
    prepareDatasets() {
      const datasets = [];
      ['creationToAssignmentTime', 'assignmentToResponseTime', 'responseToApprovalTime', 'approvalToMergeTime']
        .forEach(key => {
          datasets.push({
            label: this.$i18n.t(`message.metrics.${key}Label`),
            data: this.getTrimmedData.map((value) => value[key]),
            color: this.colors[`${key}Color`],
          });
        });

      return datasets;
    },
  },
  methods: {
    meanTime(dataArray) {
      const meanValue = mean(dataArray);

      return timeFormatter(
        meanValue,
        this.$i18n.t('message.time.day'),
        this.$i18n.t('message.time.hour'),
        this.$i18n.t('message.time.minute'),
      );
    },
    prepareSummary() {
      return ['creationToAssignment', 'assignmentToResponse', 'responseToApproval', 'approvalToMerge']
        .map(key => ({
          textTop: this.$i18n.t(`message.metrics.${key}SummaryText`),
          textBottom: this.$i18n.t('message.metrics.bottomSummaryText'),
          value: this.meanTime(this.getTrimmedData.map((value) => value[`${key}Time`])),
        }));
    },
  },
};
</script>
