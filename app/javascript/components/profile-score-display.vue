<template>
  <div class="profile__score">
    <div>{{ score }}</div>
  </div>
</template>

<script>

import { mapState } from 'vuex';

export default {
  computed: mapState({
    score: state => state.profile.score,
  }),
}
</script>

