<template>

  <b-container  v-if ="hasPlayed" class ="running_page">

    <b-container class="info">
      <b-row>
        <b-col cols ="6" class="account"><span style="font-weight:bold;">Account: </span>{{ ethAddress }}</b-col>
        <b-col cols="2"></b-col>
        <b-col cols ="4">
          <span> <span class ="pool">Pool Amount: </span> {{ fromEther(this.$store.state.bet.poolAmount) }} </span>
          <span> <span class ="pool">Winning Color </span> {{ winningColor }} </span>
        </b-col>
      </b-row>

      <b-row>
        <b-col cols ="6"><span style="font-weight:bold;">Balance: </span>{{ formatPrice(ethBalance) }}</b-col>
        <b-col cols ="2"></b-col>
        <!--Timer  -->
        <b-col cols ="4">
          <!-- The countdown timer is only rendered when timeLeft >= 0, and is given timeLeft as a prop -->
          <countdown v-if="timeLeft >= 0" :time="timeLeft">
      <template slot-scope="props" >
        <span class ="timer"> {{ props.minutes }} minutes, {{ props.seconds }} seconds.</span>
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
          <br>
          <!-- used for debugging -->
          <!-- <span>{{ this.selectedColors }}</span> -->
        </b-col>
      </b-row>
      <b-row>
        <!-- The :disabled prop is used for form validation, the button is not clickable until certain conditions are met. -->
        <b-col><b-button :disabled="betValue < 1 || colorSelected == ''" @click="makeBet">Make Bet</b-button></b-col>
      </b-row>
    </b-container>
    <!-- Winner & Losers Modal -->
    <WinnerModal v-if="isWinner" />
    <LoserModal v-if="isLoser" />
    <!-- If a user tries to bet more than their balance, this alert pops up and the makeBet() method is not called in the contract. -->
    <b-alert v-model="insufficientFunds" variant="danger" dismissible>
      You don't have that much to bet!
    </b-alert>
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
.timer{
  color:red;
  font-size: x-large;
  font-weight: bold;
}


</style>

<script>
import Web3 from "web3";
import { mapGetters } from "vuex";
import Swatches from 'vue-swatches';
import Spinner from '@/components/Spinner';
import WinnerModal from '@/components/WinnerModal';
import LoserModal from '@/components/LoserModal';


import Betting from "@/../build/contracts/Betting.json";
import "vue-swatches/dist/vue-swatches.min.css";

export default {
  components: {
    Swatches,
    Spinner,
    WinnerModal,
    LoserModal

   },
  data() {
    return {
      colors: [
        ['#c1272d', '#2e3192', '#22b573', '#f6db2f', '#662d91', '#f7931e'], // red, blue, green, yellow, purple, orange
      ],
      // the following initial values are modified by the Vuex store as well as the forms above
      colorSelected: '',
      betValue: 0,
      winningColor: '',
      insufficientFunds: false,
      hasPlayed: false,
      isWinner: false,
      isLoser: false,
      contractJson: Betting,
    };
  },
  // syntactic sugar for getting values from the Vuex store modules
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
    // required for the handshake between MetaMask and the app
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
    // Every time the contract is recompiled by truffle migrate --reset, the JSON in the build folder is replaced
    // therefore we need a method to fetch the current contract address
    async getContractAddress() {
      web3 = new Web3(web3.currentProvider);
      let networkID = await web3.eth.net.getId();
      let deployedAddress = this.contractJson.networks[networkID].address;
      return deployedAddress;
    },
    // used for debugging to make sure we always have access to the correct account address
    async getAccount() {
      web3 = new Web3(web3.currentProvider);
      web3.eth.getAccounts().then(console.log);
    },
    async makeBet() {
      if (this.toEther(this.betValue) >= this.ethBalance) { this.insufficientFunds = true};
      if(this.insufficientFunds) { return }; // without this, the contract will still reject the tx
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
          // from: process.env.VUE_APP_ETHADDRESS // account address stored in env variable
          from: this.ethAddress                   // account address fetched by web3
        })
        // wait for the transaction hash (confirmation) before adding selected color to user's state
        .once("transactionHash", (hash) => { this.$store.commit("bet/addSelectedColor", this.toEnum(this.colorSelected)) })
        .catch(error => alert(error.message))
    },
    // standard getters acting as bridge between the contract, Vuex store, and Bet component
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
      this.$store.commit("bet/setPoolAmount", getPoolAmount);
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
        .startBet(75)
        .send({
          // from: process.env.VUE_APP_ETHADDRESS
          from: this.ethAddress
        })
        .catch(error => alert(error.message));
    },
    // this is called when time runs out, announceWinner() is chained at the end
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
          // from: process.env.VUE_APP_ETHADDRESS
          from: this.ethAddress
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
    // watchers in Vue let us watch a value (timeLeft) and every time it changes, run a block of code
    timeLeft(time) {
      if (time <= 0 && this.$store.state.bet.isRunning && !this.$store.state.bet.hasEnded) {
        this.$store.commit("bet/setIsRunning", false);
        this.endBet()
        this.$store.commit("bet/setHasEnded", true);
      }
    }
  },
  mounted: function() {
    // we dont have cool libs like Drizzle so we have to do things the hacky way: run these getter methods 
    // every second to keep our component state in sync with the contract
    this.$nextTick(function() {
      window.setInterval(() => {
        this.getIsRunning();
        this.getEndTime();
        this.getPoolAmount();
        this.getWinningColor();
      }, 1000);
    });
  },
  created: function() {
    //grab some initial values when the component is created
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
