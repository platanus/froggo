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
  props: ['repositories', 'users'],
  mounted() {
    document.getElementById(this.users).style.display = 'none';
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
      document.getElementById(this.repositories).style.display = 'block';
      document.getElementById(this.users).style.display = 'none';
    },
    activateUsers() {
      document.getElementById(this.repositories).style.display = 'none';
      document.getElementById(this.users).style.display = 'block';
    },
  },
}
</script>
