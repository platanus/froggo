<template>
  <div class="profile-team-tags__tags-container">
    <div
      v-for="tag in tags"
      :class="`profile-team-tags__tag--${indexStyle}`"
      :key="tag.id"
    >
      {{ tag.name }}
    </div>
  </div>
</template>
<script>

export default {
  props: {
    tags: {
      type: Array,
      default: () => { },
    },
    index: {
      type: Number,
      default: 0,
    },
  },
  computed: {
    indexStyle() {
      const two = 2;

      return this.index % two > 0 ? 'even' : 'odd';
    },
  },
};
</script>

