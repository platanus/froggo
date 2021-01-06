<template>
  <div>
    <div class="display-tags">
      <p v-if="error">
        No se pudo agregar tag
      </p>

      <div
        v-if="!haveTags"
        class="display-tags__no-tags"
      >
        <span class="display-tags__no-tags-msj">
          Aún no tengo tags ...
        </span>
      </div>

      <div class="display-tags__tag-list">
        <tags-show
          :items="myTags"
          :can-add-tag="canAddTag"
          :show-btn="showBtn"
          @item-cancel="eliminateTag"
          @show-mod="showModal"
        />
      </div>
    </div>

    <transition
      name="modal"
      v-if="modal"
    >
      <div class="modal__overlay">
        <div class="modal__container">
          <button
            class="modal__close"
            @click="noShowModal"
          >
            x
          </button>
          <div class="modal__body">
            <div class="modal__dropdown">
              <clickable-dropdown
                :body-title="dropdownTitle"
                :no-items-message="noTagsMessage"
                :items="tags"
                @item-clicked="onItemClicked"
              />
            </div>

            <tags-show
              class=" modal__tags"
              :items="selectedTags"
              :can-add-tag="canAddTag"
              @item-cancel="cancelTag"
            />

            <div class="modal__footer">
              <button
                class="btn__save-tags"
                @click="addTags"
              >
                Guardar
              </button>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>
<script>
import axios from 'axios';
import ClickableDropdown from './clickable-dropdown';
import TagsShow from './tags-show';

export default {
  components: {
    ClickableDropdown,
    TagsShow,
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

  methods: {
    showModal() {
      this.modal = true;
    },
    noShowModal() {
      this.modal = false;
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
      axios.patch(`/api/github_users/${this.githubSession.user.id}`, {
        // eslint-disable-next-line camelcase
        tag_ids: [... ids],
      })
        .then((res) => {
          this.myTags = res.data.tags;
        }).catch(() => {
          this.error = true;
        });
    },
    addTags() {
      this.noShowModal();
      const ids = new Set([...this.myTags.map(this.getId), ... this.selectedTags.map(this.getId)]);
      this.editTags(ids);
      this.selectedTags = [];
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
  computed: {
    haveTags() {
      return this.myTags.length !== 0;
    },
  },
  data() {
    return {
      dropdownTitle: 'Tags',
      noTagsMessage: 'No existen tags',
      modal: false,
      selectedTags: [],
      myTags: this.userTags,
      showBtn: true,
      canAddTag: this.githubSession.user.id === this.githubUser.id,
      error: false,
    };
  },
};
</script>
