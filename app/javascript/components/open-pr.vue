<template>
  <div class="profile-prs__container">
    <div
      v-if="!recommendations"
      class="loading-icon"
    />
    <div v-else>
      <h4>
        Se ha detectado un PR tuyo con nombre:
      </h4>
      <h3>
        #{{ pr }}
      </h3>
      <v-select
        :options="users"
        label="login"
      >
        <template v-slot:no-options="{ search, searching }">
          <template v-if="searching">
            No hay coincidencias para <em>{{ search }}</em>.
          </template>
        </template>
        <template v-slot:option="option">
          <div class="select-reviewer__container">
            <img
              class="select-reviewer__picture"
              :src="option.avatar_url"
            >
            <span
              class="select-reviewer__username"
            >
              {{ option.login }}
            </span>
            <div
              :class="`select-reviewer__color-badge
                select-reviewer__color-badge--${colorFromScore(option.score)}`"
            />
          </div>
        </template>
      </v-select>
      <div class="centered">
        <button class="profile-prs__button">
          Asignar
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import colorFromScore from '../helpers/color-from-score';

export default {
  computed: {
    ...mapState({
      recommendations: state => state.profile.recommendations,
      fetchingRecommendations: state => state.profile.fetchingRecommendations,
    }),
    users() {
      return this.recommendations.all;
    },
  },
  props: {
    pr: {
      type: String,
      required: true,
    },
  },
  methods: {
    colorFromScore,
  },
};
</script>
