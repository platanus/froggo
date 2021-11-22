<template>
  <div>
    <div
      class="flex flex-row justify-between mb-1"
    >
      <p class="text-sm font-semibold mb-1">
        Acerca de mí
      </p>
      <div
        v-if="$parent.isEditing"
      >
        <froggo-button
          variant="green"
          :disabled="buttonDisabled"
          @click="submit"
        >
          Guardar
        </froggo-button>
      </div>
    </div>
    <div
      v-if="!$parent.isEditing"
    >
      <p
        v-html="this.user.description"
      />
    </div>
    <div
      v-else-if="$parent.isEditing"
      class="flex flex-row"
    >
      <textarea
        name="description"
        type="text"
        placeholder="Agrega una descripción de máximo 255 caracteres"
        class="flex flex-grow resize-none border border-gray-500 rounded w-full p-2"
        v-model="form.description"
      />
    </div>
    <p
      v-if="error"
    >
      Error: {{ this.errors }}
    </p>
  </div>
</template>

<script>

import usersApi from '../api/users';
import FroggoButton from './shared/froggo-button.vue';

export default {
  components: {
    FroggoButton,
  },
  props: {
    githubUser: {
      type: Object,
      required: true,
    },
  },
  computed: {
    buttonDisabled() {
      return this.form.description === this.user.description;
    },
  },
  methods: {
    submit() {
      usersApi.updateUser(this.githubUser.id, this.form)
        // eslint-disable-next-line max-statements
        .then((res) => {
          this.user = res.data.data.attributes;
          this.error = false;
          this.form.description = this.user.description;
        }).catch(() => {
          this.error = true;
          this.errors = 'Descripción muy larga, máximo 255 caracteres';
        });
    },
  },
  data() {
    const init = {
      user: this.githubUser,
      form: {
        description: '',
      },
      errors: '',
      error: false,
    };
    if (this.githubUser.description) {
      init.form.description = init.user.description;
    }

    return { ...init };
  },
};
</script>
