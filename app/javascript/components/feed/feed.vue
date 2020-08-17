<template>
  <ul id="example-1" style=" list-style-type:none">
    <li
      v-for="pullRequest in pullRequests"
      :key="pullRequest.id"
    >
      <div style="display: flex; flex-direction: row;">
        <div class="card"> 
          <p class="card-extended__name"> {{ pullRequest.title }} </p>
          <p class="card-extended__project"> {{ pullRequest.repository }} </p>
        </div>
        <div class="card-extended--card">
          <p class="card-extended--circle"> {{ pullRequest.gh_number }} </p>
          <button style="min-width: 240px; text-align: center;">TIL</button>
        </div>
      </div>
    </li>
  </ul>
</template>

<script>
export default {
  props: {
    pullRequests: {
      type: Array,
      required: true,
    },
  },

  data() {
    return {
      message: 'Hello World',
    };
  },
};
</script>
