<template>
  <div id="panel">
    <p>Abre el panel de configuración para trackear los repositorios.</p>
    <button id="show-modal" @click="showModal = true">Configuración</button>
    <modal v-if="showModal" @close="showModal = false">
    </modal>
  </div>
</template>
<script>
import modal from './modal.vue';

export default {
  components: {
    modal,
  },
  data: function () {
    return {
      showModal: false,
    }
  },
}
</script>

