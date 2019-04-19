<template>

  <b-container  v-if ="hasPlayed" class ="running_page">

    <b-container class="info">
      <b-row>
        <b-col cols ="6" class="account"><span style="font-weight:bold;">Account: </span>{{ethAddress }}</b-col>
        <!--Vuex store: {{ this.$store.state.bet.color }}-->
        <b-col cols="2"></b-col>
        <b-col cols ="4">
          <span placeholder="Pool Amount"> <span class ="pool">Pool Amount: </span> {{fromEther(poolAmount)}} </span>
        </b-col>
      </b-row>

      <b-row>
        <b-col cols ="6"><span style="font-weight:bold;">Balance: </span>{{ formatPrice(ethBalance) }}</b-col>
        <b-col cols ="2"></b-col>
        <b-col cols ="4">   
          <countdown v-if="timeLeft >= 0" :time="timeLeft">
      <template slot-scope="props">
        Time Remaining: {{ props.minutes }} minutes, {{ props.seconds }} seconds.
        </template>
    </countdown>
    </b-col>
      </b-row>
    </b-container>

    <!--Spinner Animation  -->
    <Spinner/>

    <b-container class = "input_container">
      <b-row>
        <b-col cols ="4">
        </b-col>
        <b-col cols="4">
          <span style="color:black;font-weight:bold;">Place Bet</span><b-form-input v-model="betValue" placeholder="$$$$$$"></b-form-input>
        </b-col>
        <b-col cols ="4">
        </b-col>
      </b-row>
      <b-row>
        <b-col style ="padding-bottom:20px;">
          <span style="color:black;font-weight:bold;">Select color:</span>
          <swatches v-model="color" :colors="colors" row-length="5"></swatches>
          <span>{{color}}</span>
        </b-col>
      </b-row>
      <b-row>
        <b-col><b-button @click="makeBet">Make Bet</b-button></b-col>
      </b-row>
    </b-container>
  </b-container>

  <b-container fluid v-else>
    <b-row class ="button_page" align-v="center">
      <b-col></b-col>
      <b-col><b-button size="lg" variant="dark" @click="startBet(); hasPlayed = true;">Play!</b-button></b-col>
      <b-col></b-col>
    </b-row>
  </b-container>


</template>
<style scoped>
.button_page{
  width:100vw;
  height:94vh;
  background-color:#37775c;
  padding-bottom:56px;
}
.running_page{
  margin-top:20px;
  height:100%;
}

  /* width:100vw;
  height:94vh; */
  
  /* background-color:#37775c; */


/* @media (max-width: 425px){
  .running_page{
    margin-top:40%;
}
} */
.spinner{
  background-color:red;
  width:300px;
  height:300px;

}
.input_container{
  padding:35px;
  /* width: 35%; */
  /* background-color:#37775c; */
}

.info{
  overflow:hidden;
  margin-bottom:10px;
  /* width:35%; */
}
.account{
  overflow: hidden;
}
.pool{
  text-align:right;
  font-weight:bold;
}


</style>

<script>
import Web3 from "web3";
import { mapGetters } from "vuex";
import Swatches from 'vue-swatches';
import Spinner from '@/components/Spinner';


import Betting from "@/../build/contracts/Betting.json";
import "vue-swatches/dist/vue-swatches.min.css";

export default {
  components: {
    Swatches,
    Spinner

   },
  data() {
    return {
      color: '',
      colors: [
        ['#f7931e', '#2e3192', '#22b573', '#c1272d', '#662d91', '#56c6d0' ],
      ],
      colorSelected: "",
      betValue: 0,
      poolAmount: 0,
      hasPlayed: false,
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
