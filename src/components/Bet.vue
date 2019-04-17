<template>
  <div class="container">
    <h1>This is the bet page</h1>
    <b-button @click="startBet()">Start Bet</b-button>
    <br>
    <b-button @click="endBet()">End Bet</b-button>
    <br>
    <p v-if="this.$store.state.bet.isRunning">Running</p>
    <br>
    <br>
    <b-form-input v-model="colorSelected" placeholder="Enter color to bet on"></b-form-input>
    <b-form-input v-model="betValue" placeholder="Enter amount to bet"></b-form-input>
    <b-button @click="makeBet">Make Bet</b-button>
    <br>
    <br>
    <b-button @click="getEndTime">Get End Time</b-button>
    <h4>Balance: {{ formatPrice(ethBalance) }}</h4>
    <h4>Address: {{ ethAddress }}</h4>
    <h4>Pool amount: {{ this.fromEther(this.poolAmount) }}</h4>
    <h4>Bet value: {{ this.$store.state.bet.color }}</h4>
    <countdown v-if="timeLeft >= 0" :time="timeLeft">
      <template
        slot-scope="props"
      >Time Remaining：{{ props.days }} days, {{ props.hours }} hours, {{ props.minutes }} minutes, {{ props.seconds }} seconds.</template>
    </countdown>
  </div>
</template>

<script>
import Web3 from "web3";
import { mapGetters } from "vuex";

import Betting from "@/../build/contracts/Betting.json";

export default {
  data() {
    return {
      colorSelected: "",
      betValue: 0,
      poolAmount: 0,
      contractJson: Betting,
    };
  },
  computed: mapGetters({
    web3Instance: "getWeb3Instance",
    ethBalance: "getEthBalance",
    ethAddress: "getEthAddress",
    timeLeft: "bet/getTimeLeft"
  }),
  betValue() {
    return this.$store.state.bet.value;
  },
  timeLeft() {
    return this.$store.state.bet.timeLeft;
  },
  isRunning() {
    return this.$store.state.bet.isRunning;
  },
  methods: {
    initWeb3: () => {
      if (window.ethereum) {
        window.web3 = new Web3(ethereum);
        try {
          ethereum.enable();
        } catch (err) {
          alert("user denied access to metamask");
        }
      }
    },

    async getContractAddress() {
      web3 = new Web3(web3.currentProvider);
      let networkID = await web3.eth.net.getId();
      // let networkID = 5777 //hard code this for now as getId() isn't working
      let deployedAddress = this.contractJson.networks[networkID].address;
      return deployedAddress;
    },
    async getAccount() {
      web3 = new Web3(web3.currentProvider);
      web3.eth.getAccounts().then(console.log);
    },
    async makeBet() {
      web3 = new Web3(web3.currentProvider);
      let deployedAddress = await this.getContractAddress();
      let myContract = new web3.eth.Contract(
        this.contractJson.abi,
        deployedAddress
      );
      let makeBet = await myContract.methods
        .makeBet(this.colorSelected)
        .send({
          value: this.toEther(this.betValue),
          from: process.env.VUE_APP_ETHADDRESS
        })
        .once("receipt", function(receipt) {})
        // .on('confirmation', function(confNumber, receipt){ confNumber => this.$store.commit("bet/setColor", this.colorSelected) })
        // .then(this.$store.commit("bet/setColor", this.colorSelected))
        .catch(error => alert(error.message));
    },
    async getIsRunning() {
      web3 = new Web3(web3.currentProvider);
      let deployedAddress = await this.getContractAddress();
      let myContract = new web3.eth.Contract(
        this.contractJson.abi,
        deployedAddress
      );
      let getIsRunning = await myContract.methods.getIsRunning().call();
      // this.running = getIsRunning;
      this.$store.commit("bet/setIsRunning", getIsRunning);
      // console.log("Is running? " + this.running)
    },
    async getEndTime() {
      web3 = new Web3(web3.currentProvider);
      let deployedAddress = await this.getContractAddress();
      let myContract = new web3.eth.Contract(
        this.contractJson.abi,
        deployedAddress
      );
      let getEndTime = await myContract.methods.getEndTime().call();
      this.endTime = getEndTime;
      let d = new Date(0);
      d.setUTCSeconds(this.endTime);
      this.d = d;
      this.$store.commit("bet/setTimeLeft", d - Date.now());
    },
    async getPoolAmount() {
      web3 = new Web3(web3.currentProvider);
      let deployedAddress = await this.getContractAddress();
      let myContract = new web3.eth.Contract(
        this.contractJson.abi,
        deployedAddress
      );
      let getPoolAmount = await myContract.methods.getPoolAmount().call();
      this.poolAmount = getPoolAmount;
    },
    async startBet() {
      web3 = new Web3(web3.currentProvider);
      let deployedAddress = await this.getContractAddress();
      let myContract = new web3.eth.Contract(
        this.contractJson.abi,
        deployedAddress
      );
      let startBet = await myContract.methods
        .startBet(30)
        .send({
          from: process.env.VUE_APP_ETHADDRESS
        })
        .once("transactionHash", function(hash) {})
        .once("receipt", function(receipt) {})
        // .on('confirmation', function(confNumber, receipt){ this.$store.commit("bet/setIsRunning", true) })
        // .on('confirmation', function(confNumber, receipt){ receipt => this.getEndTime() })
        .catch(error => alert(error.message));
    },
    async endBet() {
      web3 = new Web3(web3.currentProvider);
      let deployedAddress = await this.getContractAddress();
      let myContract = new web3.eth.Contract(
        this.contractJson.abi,
        deployedAddress
      );
      let endBet = await myContract.methods
        .endBet()
        .send({
          from: process.env.VUE_APP_ETHADDRESS
        })
        // .then(this.$store.commit("bet/setValue", this.contractValue))
        // .then(this.running = this.getRunning())
        .catch(error => alert(error.message));
    },
    formatPrice(value) {
      return value && value !== 0
        ? web3Instance.utils.fromWei(value, "ether") + " ether"
        : "-";
    },
    toEther(value) {
      return value * 1000000000000000000;
    },
    fromEther(value) {
      return value / 1000000000000000000;
    }
  },
  watch: {
    timeLeft(time) {
      if (time <= 0 && this.$store.state.bet.isRunning) {
        this.$store.commit("bet/setIsRunning", false);
        this.endBet();
      }
    }
  },
  mounted: function() {
    this.$nextTick(function() {
      window.setInterval(() => {
        this.getIsRunning();
      }, 4000);
      window.setInterval(() => {
        this.getEndTime();
        this.getPoolAmount();
      }, 1000);
    });
  },
  created: function() {
    window.addEventListener("load", () => {
      setTimeout(() => {
        this.$store.dispatch("fetchWeb3Instance");
      }, 100);
    });
    this.initWeb3();
    this.getAccount();
    this.getPoolAmount();
  }
};
</script>

<style scoped lang="scss"></style>
