<template>
  <div class="profile-metrics">
    <h3>Métricas de tiempo: Tiempo entre creación de PR y asignación de revisor</h3>
    <div
      v-if="beingFetched"
      class="loading-icon"
    />
    <div
      v-else-if="Object.keys(pullRequestsInformation).length === 0"
    >
      <span>No hay información para mostrar</span>
    </div>
    <div
      v-else
    >
      <b>Promedio personal: {{ userTimeMean }} segundos</b>
      <br>
      <table>
        <tr>
          <th>Pull request</th>
          <th>creación</th>
          <th>asignación de revisor</th>
          <th>tiempo entre creación y asignación</th>
        </tr>
        <tr
          v-for="pr_information in pullRequestsInformation"
          :key="pr_information.id"
        >
          <td>{{ pr_information.pr_title }}</td>
          <td>{{ pr_information.pr_created_at }}</td>
          <td>{{ pr_information.review_request_created_at }}</td>
          <td>{{ pr_information.time_delta }} segundos</td>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';

export default {
  computed: mapState({
    pullRequestsInformation: state => state.profile.pullRequestInformation,
    userTimeMean: state => state.profile.userMeanTime,
    beingFetched: state => state.profile.fetchingPullRequestInformation,
  }),
};
</script>
