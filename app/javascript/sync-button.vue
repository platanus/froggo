<template>
  <form v-bind:action="url" accept-charset="UTF-8" method="post">
    <input type="submit" name="commit" value="sync" data-disable-with="sync" class="card-extended__little-button">
    <spinner class="sync-spinner"></spinner>
  </form>
</template>

<script>
  import Spinner from 'vue-simple-spinner';

  export default {
    props: ['url'],
    data() {
      return {
        url: this.url
      }
    },
    components: {
      Spinner
    },
    methods: {
    }
  }
</script>
