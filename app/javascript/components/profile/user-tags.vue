<template>
  <div>
    <p class="text-sm font-semibold mb-1">
      Mis tags
    </p>
    <div class="flex flex-row items-center text-froggoBlue">
      <div
        v-for="tag in myTags"
        :key="tag.id"
        class="flex flex-row px-3 py-2 bg-red-500 rounded-full text-white mr-2 items-center"
      >
        <div class="mr-1">
          {{ tag.name }}
        </div>
        <button
          v-if="$parent.isEditing"
          @click="eliminateTag(tag.id)"
        >
          <inline-svg
            :src="require('../../../assets/images/close.svg').default"
            class="flex-grow-0 fill-current text-sm"
          />
        </button>
      </div>
      <button
        v-if="$parent.isEditing"
        @click="toggleModal"
      >
        <inline-svg
          :src="require('../../../assets/images/boton-agregar.svg').default"
          class="flex-grow-0 fill-current h-5 w-5"
        />
      </button>
    </div>
    <transition
      name="modal"
      v-if="showModal"
    >
      <div class="modal__overlay">
        <div class="modal__container">
          <div class="modal__header">
            <span class="modal__header-title"> Añade tus tags </span>
            <button
              class="modal__close"
              @click="toggleModal"
            >
              <img
                class="modal__close-img"
                :src="require('../../../assets/images/cancel.png').default"
              >
            </button>
          </div>
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
              class="modal__tags"
              :items="selectedTags"
              :can-add-tag="$parent.isEditing"
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

import ClickableDropdown from '../clickable-dropdown';
import UsersApi from '../../api/users';

export default {
  components: {
    ClickableDropdown,
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

