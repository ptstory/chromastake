import Vue from "vue";
import Router from "vue-router";
import About from "./views/About.vue";
import Betting from "./views/Betting.vue";

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: "/",
      name: "betting",
      component: Betting
    },
    {
      path: "/about",
      name: "about",
      component: About
    }
  ]
});
