<template>
  <header class="px-6 py-3 bg-black">
    <div class="flex">
      <div class="flex items-center flex-1">
        <inline-svg
          :src="require('assets/images/froggo-logo.svg').default"
          class="h-6"
        />
      </div>
      <div class="flex items-center">
        <froggo-dropdown>
          <template #btn>
            <div class="flex items-center mr-8">
              <span
                class="w-10 h-10 mr-1 rounded-full bg-white bg-opacity-50"
              />
              <inline-svg
                :src="require('assets/images/chevron-down.svg').default"
                class="text-white fill-current h-6 w-6 ml-2"
              />
            </div>
          </template>
          <template #body>
            <div class="mt-4 bg-white w-56">
              <div
                v-if="userOrganizations"
                class="grid grid-rows-auto gap-1"
              >
                <div
                  v-for="organization in userOrganizations"
                  :key="organization.id"
                  class="flex items-center m-4 opacity-50"
                >
                  <img
                    v-if="organization.avatar_url"
                    :src="organization.avatar_url"
                    class="w-10 h-10 mr-5 rounded-full"
                  >
                  <span
                    v-else
                    class="w-10 h-10 mr-5 rounded-full bg-black bg-opacity-50"
                  />
                  <p class="my-auto font-medium">
                    {{ organization.login }}
                  </p>
                </div>
              </div>
              <div
                v-else
                class="flex items-center p-4"
              >
                <p class="my-auto font-medium">
                  {{ $i18n.t('message.global.header.noOrganizations') }}
                </p>
              </div>
            </div>
          </template>
        </froggo-dropdown>
        <div
          class="h-8 mr-8 border-r-2 border-white"
        />

        <froggo-dropdown>
          <template #btn>
            <div class="flex items-center">
              <img
                :src="user.avatar_url"
                class="w-10 h-10 mr-1 rounded-full"
              >
              <inline-svg
                :src="require('assets/images/chevron-down.svg').default"
                class="text-white fill-current h-6 w-6 ml-2"
              />
            </div>
          </template>
          <template #body>
            <div class="mt-4 bg-white w-56">
              <div class="grid grid-rows-auto gap-1 font-medium whitespace-no-wrap">
                <a
                  href="/me"
                  class="p-4"
                >
                  {{ $i18n.t('message.global.header.profile') }}
                </a>
                <a
                  :href="organizationPath"
                  class="p-4"
                >
                  {{ $i18n.t('message.global.header.organizations') }}
                </a>
                <a
                  :href="orgAuthenticatePath"
                  class="p-4"
                >
                  {{ $i18n.t('message.global.header.givePermission') }}
                </a>
                <a
                  :href="closeSessionPath"
                  class="p-4"
                >
                  {{ $i18n.t('message.global.header.closeSession') }}
                </a>
              </div>
            </div>
          </template>
        </froggo-dropdown>
      </div>
    </div>
  </header>
</template>

<script>
export default {
  props: {
    user: {
      type: Object,
      default: () => {},
    },
    userOrganizations: {
      type: Array,
      default: () => [],
    },
    organizationPath: {
      type: String,
      default: '',
    },
    orgAuthenticatePath: {
      type: String,
      default: '',
    },
    closeSessionPath: {
      type: String,
      default: '',
    },
  },
};
</script>
