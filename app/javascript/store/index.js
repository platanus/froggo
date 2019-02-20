import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';

import profile from './modules/profile';
import publicDashboard from './modules/public-dashboard';

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    profile,
    publicDashboard,
  },
});
