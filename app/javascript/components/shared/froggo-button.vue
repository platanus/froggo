<template>
  <component
    :is="tag"
    class="flex items-center leading-none transition-colors duration-150 ease-in-out shadow focus:outline-none"
    :class="[colorClasses, shapeClasses, textClasses]"
    :disabled="disabled"
    v-on="$listeners"
    v-bind="$attrs"
  >
    <inline-svg
      v-if="iconFileName"
      :src="require(`../../../assets/images/icons/${iconFileName}`).default"
      class="flex-grow-0 fill-current"
    />
    <div
      v-if="!onlyIcon"
      class="flex-1 text-center"
    >
      <slot />
    </div>
    <inline-svg
      v-if="rightIconFileName"
      :src="require(`../../../assets/images/icons/${rightIconFileName}`).default"
      class="flex-grow-0 fill-current"
    />
  </component>
</template>

<script>

export default {
  props: {
    tag: { type: String, default: 'button' },
    variant: { type: String, default: 'blue' },
    recommendation: { type: Boolean, default: false },
    iconFileName: { type: String, default: null },
    small: { type: Boolean, default: false },
    disabled: { type: Boolean, default: false },
    rightIconFileName: { type: String, default: null },
    onlyIcon: { type: Boolean, default: false },
  },
  computed: {
    colorClasses() {
      const classes = {
        black: 'text-black',
        blue: 'text-froggoBlue border-froggoBlue hover:bg-gray-100 text-md',
        red: 'text-red-600 border-red-600 hover:bg-gray-100 text-md',
        green: 'text-froggoGreen border-froggoGreen hover:bg-gray-100 text-md',
        disabled: 'text-gray-300 border-gray-300 cursor-default text-md',
      };
      const variant = this.disabled ? 'disabled' : this.variant;

      return classes[variant];
    },
    textClasses() {
      const classesWithText = this.recommendation ? 'p-3 text-base' : 'h-8 px-10 text-md';
      const classesWithoutText = 'h-8 w-8 p-2 text-md';

      return this.onlyIcon ? classesWithoutText : classesWithText;
    },
    shapeClasses() {
      const primaryStyle = 'rounded-lg border';
      const recommendationStyle = 'rounded-r-lg border-r border-t border-b';

      return this.recommendation ? recommendationStyle : primaryStyle;
    },
  },
};
</script>
