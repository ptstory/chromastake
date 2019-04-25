const state = {
  value: "",
  color: "",
  selectedColors: [],
  isRunning: false,
  hasEnded: false,
  poolAmount: 0,
  timeLeft: 0,
};

const getters = {
  state: state => {
    return state;
  },
  getTimeLeft: state => {
    return state.timeLeft;
  },
  getSelectedColors: state => {
    return state.selectedColors;
  }
};

// const actions = {
//   getValue({ commit }) {
//     value => {
//       commit("setValue", value);
//     };
//   }
// };

const mutations = {
  setValue(state, value) {
    state.value = value;
  },
  setColor(state, color) {
    state.color = color;
  },
  setTimeLeft(state, timeLeft) {
    state.timeLeft = timeLeft;
  },
  setPoolAmount(state, poolAmount) {
    state.poolAmount = poolAmount;
  },
  setIsRunning(state, isRunning) {
    state.isRunning = isRunning;
  },
  setHasEnded(state, hasEnded) {
    state.hasEnded = hasEnded;
  },
  addSelectedColor(state, color) {
    state.selectedColors.push(color)
  }
};

export default {
  namespaced: true,
  state,
  getters,
  // actions,
  mutations
};