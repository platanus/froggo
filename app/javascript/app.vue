<template>
<div id="selector">

    <select v-model="selected">
      <option v-for="option in options" v-bind:value="option.value">
        {{ option.text }}
      </option>
    </select>
    <button v-on:click="redirect(selected)">Go to dahboard</button>

</div>
</template>

<script>

function getCookies() {
  const cookies_saved = document.cookie.split('; ');
  let cookies = {};
  for (let i = 0; i < cookies_saved.length; i++) {
    const temp = cookies_saved[i].split('=');
    cookies[temp[0]] = temp[1];
  }
  return cookies;
}

function getOrgsCookie() {
  return JSON.parse(decodeURIComponent(getCookies()['orgs']));
}

function currentOrg() {
  if(getCookies()['currentOrg'] === undefined) {
    document.cookie = "currentOrg="+getOrgsCookie()[0].login;
  }

  return getCookies()['currentOrg'];
}

export default {
  data: function () {
    return {
      selected: currentOrg(),
    }
  },
  computed: {
    options() {
      currentOrg();
      let cookies = getOrgsCookie();
      let options = [];
      for (let i = 0; i < cookies.length; i++) {
        options.push({text: cookies[i].login, value: cookies[i].login });
      }
      return options;
    }
  },
  methods: {
    redirect(dashboard) {
      document.cookie = "currentOrg="+dashboard;
      document.location.href = '/dashboard/' + dashboard;
    }
  }
}
</script>

<style scoped>
/* p {
  font-size: 2em;
  text-align: center;
} */
</style>

