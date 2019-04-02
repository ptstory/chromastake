import Vue from "vue";
import Vuex from "vuex";
import bet from "./modules/bet";
import web3 from "@coatofbits/vuex-web3";

Vue.use(Vuex);

const store = new Vuex.Store({
  modules: {
    bet,
    web3
  },
  strict: process.env.NODE_ENV !== "production"
});

export default store;
