<template>

  <b-container  v-if ="hasPlayed" class ="running_page">

    <b-container class="info">
      <b-row>
        <b-col cols ="6" class="account"><span style="font-weight:bold;">Account: </span>{{ ethAddress }}</b-col>
        <b-col cols="2"></b-col>
        <b-col cols ="4">
          <span> <span class ="pool">Pool Amount: </span> {{ fromEther(poolAmount) }} </span>
          <span> <span class ="pool">Winning Color </span> {{ winningColor }} </span>
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
          <swatches v-model="colorSelected" :colors="colors" row-length="5"></swatches>
          <span>{{ toColorName(colorSelected) }}</span>
          <br>
          <span v-if="isWinner">YOU ROCK</span>
          <span v-if="isLoser">YOU SUCK</span>
          <br>
          <span>{{ this.selectedColors }}</span>
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
      colors: [
        ['#c1272d', '#2e3192', '#22b573', '#f6db2f', '#662d91', '#f7931e'], // red, blue, green, yellow, purple, orange
      ],
      colorSelected: '',
      betValue: 0,
      poolAmount: 0,
      winningColor: '',
      hasPlayed: false,
      isWinner: false,
      isLoser: false,
      contractJson: Betting,
    };
  },
  computed: mapGetters({
    web3Instance: "getWeb3Instance",
    ethBalance: "getEthBalance",
    ethAddress: "getEthAddress",
    timeLeft: "bet/getTimeLeft",
    selectedColors: "bet/getSelectedColors"
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
  selectedColors() {
    return this.$store.state.bet.selectedColors;
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
        .makeBet(this.toEnum(this.colorSelected)) // toEnum() returns the corresponding enum for the color code
        .send({
          value: this.toEther(this.betValue),
          from: process.env.VUE_APP_ETHADDRESS
        })
        .once("transactionHash", (hash) => { this.$store.commit("bet/addSelectedColor", this.toEnum(this.colorSelected)) }) // wait for the transaction hash (confirmation) before adding selected color to user's state
        .catch(error => alert(error.message))
    },
    async getIsRunning() {
      web3 = new Web3(web3.currentProvider);
      let deployedAddress = await this.getContractAddress();
      let myContract = new web3.eth.Contract(
        this.contractJson.abi,
        deployedAddress
      );
      let getIsRunning = await myContract.methods.getIsRunning().call();
      this.$store.commit("bet/setIsRunning", getIsRunning);
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
    async getWinningColor() {
      web3 = new Web3(web3.currentProvider);
      let deployedAddress = await this.getContractAddress();
      let myContract = new web3.eth.Contract(
        this.contractJson.abi,
        deployedAddress
      );
      let getWinningColor = await myContract.methods.getWinningColor().call();
      this.winningColor = getWinningColor;
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
      .then(this.announceWinner())
    },
    formatPrice(value) {
      return value && value !== 0
        ? web3Instance.utils.fromWei(value, "ether") + " ether"
        : "-";
    },
    announceWinner(){
      this.$store.state.bet.selectedColors.includes(Number(this.winningColor)) ? this.isWinner = true : this.isLoser = true
    },
    toEther(value) {
      return value * 1000000000000000000;
    },
    fromEther(value) {
      return value / 1000000000000000000;
    },
    toEnum(color){ //takes in color code from the swatch component and returns an enum the contract can understand
      const m = new Map([['#c1272d', 0], ['#2e3192', 1], ['#22b573', 2], ['#f6db2f', 3], ['#662d91', 4], ['#f7931e', 5]])
      return m.get(color)
    },
    toColorName(code){ //takes in color code from the swatch component and returns a color name the user will recognize
      const m = new Map([['#c1272d', 'red'], ['#2e3192', 'blue'], ['#22b573', 'green'], ['#f6db2f', 'yellow'], ['#662d91', 'purple'], ['#f7931e', 'orange']])
      return m.get(code)
    }
  },
  watch: {
    timeLeft(time) {
      if (time <= 0 && this.$store.state.bet.isRunning) {
        this.$store.commit("bet/setIsRunning", false);
        this.endBet()
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
        this.getWinningColor();
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
    this.getWinningColor();
  }
};
</script>

<style scoped lang="scss"></style>
