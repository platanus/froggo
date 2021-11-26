<template>
  <div>
    <div>
      <div class="flex flex-row justify-between">
        <p class="text-lg font-semibold mb-6">
          Mis datos
        </p>
        <froggo-button
          v-if="$parent.canEdit"
          class="inline-flex items-center px-2"
          variant="blue"
          :icon-file-name="editIcon"
          :only-icon="true"
          @click="toggleEdit"
        />
      </div>
      <div class="mb-4">
        <profile-description
          :github-user="githubUser"
          :github-session="githubSession"
        />
      </div>
      <div>
        <user-tags
          :github-user="githubUser"
          :github-session="githubSession"
          :tags="tags"
          :user-tags="userTags"
        />
      </div>
    </div>
  </div>
</template>

<script>

import FroggoButton from '../shared/froggo-button.vue';
import ProfileDescription from '../profile-description.vue';
import UserTags from './user-tags.vue';

export default {
  components: {
    FroggoButton,
    ProfileDescription,
    UserTags,
  },
  props: {
    githubUser: {
      type: Object,
      required: true,
    },
    githubSession: {
      type: Object,
      required: true,
    },
    tags: {
      type: Array,
      required: true,
    },
    userTags: {
      type: Array,
      required: true,
    },
  },
  computed: {
    editIcon() {
      return this.isEditing ? 'close-icon.svg' : 'edit-icon.svg';
    },
  },
  methods: {
    toggleEdit() {
      this.isEditing = !this.isEditing;
    },
  },
  data() {
    return {
      isEditing: false,
    };
  },
};
</script>
