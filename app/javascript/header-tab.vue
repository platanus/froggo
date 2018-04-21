<template>
  <div>
   <div class="card-tab__button" v-on:click="change()">
      <span v-if="repositoryView">{{ $t("message.settings.adminUsers") }}</span>
      <span v-else>{{ $t("message.settings.adminRepos") }}</span>
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      repositoryView: true,
    }
  },
  mounted() {
    document.getElementById('tab-users').style.display = "none";
  },
  methods: {
    change() {
      this.$data.repositoryView = !this.$data.repositoryView;
      if (this.$data.repositoryView) {
        this.activateRepostory();
      } else {
        this.activateUsers();
      }
    },
    activateRepostory() {
      document.getElementById('tab-repositories').style.display = "block";
      document.getElementById('tab-users').style.display = "none";
    },
    activateUsers() {
      document.getElementById('tab-repositories').style.display = "none";
      document.getElementById('tab-users').style.display = "block";
    },
  },
}
</script>
