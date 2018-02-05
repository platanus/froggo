<template>
<div>
  <div>{{ repository.name }}</div>
</div>
</template>

<script>

export default {
  data: function () {
    return {
      repository: this.value,
    }
  },
  props: ['value'],
}
</script>
