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
import UsersApi from '../../api/users';
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
    toggleModal() {
      this.showModal = !this.showModal;
      this.selectedTags = [];
    },
    onItemClicked(event) {
      if (!this.myTags.map(this.getId).includes(event.item.id) &&
          !this.selectedTags.map(this.getId).includes(event.item.id)) {
        this.selectedTags.push(event.item);
      }
    },
    getId(element) {
      return element.id;
    },
    editTags(ids) {
      UsersApi.updateUser(this.githubSession.user.id, {
        tagIds: [... ids],
      })
        .then((res) => {
          this.myTags = res.data.data.attributes.tags;
        }).catch(() => {
          this.error = true;
        });
    },
    addTags() {
      const ids = new Set([...this.myTags.map(this.getId), ... this.selectedTags.map(this.getId)]);
      this.editTags(ids);
      this.toggleModal();
    },
    eliminateTag(itemId) {
      let ids = this.myTags.map(this.getId);
      ids = ids.filter((item) => item !== itemId);
      this.editTags(ids);
    },
    cancelTag(itemId) {
      this.selectedTags = this.selectedTags.filter((item) => item.id !== itemId);
    },
  },
  data() {
    return {
      isEditing: false,
      dropdownTitle: 'Seleccionar tags',
      noTagsMessage: 'No existen tags',
      showModal: false,
      selectedTags: [],
      myTags: this.userTags,
      error: false,
    };
  },
};
</script>
