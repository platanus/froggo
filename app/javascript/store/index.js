import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';

import scores from './modules/scores';

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    scores,
  },
});
