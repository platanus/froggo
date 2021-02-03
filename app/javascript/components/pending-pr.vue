<template>
  <div class="pr-to-assign">
    <div
      v-if="!recommendations"
      class="loading-icon"
    />
    <div v-else>
      <h4>
        Se ha detectado un PR tuyo con el nombre:
      </h4>
      <h3 class="pr-to-assign__title">
        #{{ pr }}
      </h3>
      <div>
        <select>
          <option
            v-for="user in users()"
            :value="user.id"
            :key="user.id"
          >
            {{ user.login }}
          </option>
        </select>
        <button class="card-pr__button-color">
          ASIGNAR!
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';

export default {
  computed: mapState({
    recommendations: state => state.profile.recommendations,
    fetchingRecommendations: state => state.profile.fetchingRecommendations,
  }),
  props: {
    pr: {
      type: String,
      required: true,
    },
  },
  methods: {
    users() {
      return this.recommendations.all;
    },
  },
};
</script>
