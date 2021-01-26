<template>
  <div>
    <div
      v-for="item in items"
      :key="item.id"
      class="tag-list"
    >
      <div class="tag-list__tag">
        {{ item.name }}
      </div>
      <button
        v-if="canAddTag"
        class="tag-list__del-tag"
        @click="cancelTag(item.id)"
      >
        <img
          class="tag-list__img-del-tag"
          :src="require('../../assets/images/close.png').default"
        >
      </button>
    </div>
    <button
      class="tag-list__add-tag"
      @click="showModal"
      v-if="canAddTag && showBtn"
    >
      <img
        class="tag-list__img-add-tag"
        :src="require('../../assets/images/boton-agregar.svg').default"
      >
    </button>
  </div>
</template>

<script>
export default {
  props: {
    items: {
      type: Array,
      required: true,
    },
    canAddTag: {
      type: Boolean,
      required: true,
    },
    showBtn: {
      type: Boolean,
      default: false,
    },
  },
  methods: {
    cancelTag(event) {
      this.$emit('item-cancel', event);
    },
    showModal(event) {
      this.$emit('show-mod', event);
    },
  },
};
</script>
