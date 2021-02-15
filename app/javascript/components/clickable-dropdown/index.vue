<template>
  <dropdown
    ref="parentDropdown"
    class="select"
  >
    <div
      class="select__btn"
      :class="whiteMode && 'select__btn select__btn--white'"
      :style="{ width: `${width}px`}"
      slot="btn"
    >
      <span
        :class="whiteMode? 'select__title--light' : 'select__title'"
      >
        <span
          v-if="selectedItem"
        >
          <span>
            {{ selectedItem ? (selectedItem.name ? selectedItem.name : selectedItem.login) : noItemsMessage }}
          </span>
        </span>

        <span
          v-else
        >
          {{ noItemsMessage }}
        </span>
      </span>
    </div>
    <div
      slot="body"
      class="select__body"
    >
      <div
        v-if="bodyTitle"
        class="select-body__title"
      >
        {{ bodyTitle }}
      </div>
      <div
        v-if="allOption"
        class="select__option"
        @click="itemClicked({ index: -1 })"
      >
        {{ allOption }}
      </div>
      <div
        v-for="(item, index) in items"
        class="select__option"
        @click="itemClicked({ item, index })"
        :key="index"
      >
        <div>
          {{ item.name ? item.name : item.login }}
        </div>
      </div>
    </div>
  </dropdown>
</template>

<script>
export default {
  props: {
    bodyTitle: {
      type: String,
      default: '',
    },
    noItemsMessage: {
      type: String,
      default: '',
    },
    items: {
      type: Array,
      default() {
        return [];
      },
    },
    defaultIndex: {
      type: Number,
      default: 0,
    },
    whiteMode: {
      type: Boolean,
      default: false,
    },
    allOption: {
      type: String,
      default: '',
    },
    width: {
      type: Number,
      default: 200,
    },
  },
  data() {
    return {
      selectedItemIndex: this.defaultIndex,
    };
  },
  computed: {
    selectedItem() {
      return this.selectedItemIndex === -1 ?
        null :
        this.items[this.selectedItemIndex];
    },
  },
  methods: {
    itemClicked(event) {
      this.selectedItemIndex = event.index;
      this.$refs.parentDropdown.closeDropdown();
      this.$emit('item-clicked', event);
    },
  },
  watch: {
    items() {
      this.selectedItemIndex = this.defaultIndex;
    },
  },
};
</script>
