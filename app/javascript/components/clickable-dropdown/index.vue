<template>
  <dropdown
    ref="parentDropdown"
    class="select"
  >
    <div
      class="select__btn"
      :class="[fullWidthMode && 'select__btn select__btn--full-width',
               centerMode && 'select__btn select__btn--center']"
      slot="btn"
    >
      <span
        :class="centerMode? 'select__title--center' : 'select__title'"
      >
        <span
          v-if="selectedItem"
        >
          <div
            v-if="colorMode"
            :class="`select__color-badge select__color-badge--${selectedItem.name}`"
          />
          <span
            v-else
          >
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
      :class="colorMode? 'select__body--color' : 'select__body'"
    >
      <div
        v-if="bodyTitle"
        class="select-body__title"
      >
        {{ bodyTitle }}
      </div>
      <div
        v-for="(item, index) in items"
        :class="colorMode? 'select__option--color' : 'select__option'"
        @click="itemClicked({ item, index })"
        :key="index"
      >
        <div
          v-if="colorMode"
          :class="`select__color-badge select__color-badge--${item.name}`"
        />
        <div v-else>
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
      required: true,
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
    colorMode: {
      type: Boolean,
      default: false,
    },
    fullWidthMode: {
      type: Boolean,
      default: false,
    },
    centerMode: {
      type: Boolean,
      default: false,
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
