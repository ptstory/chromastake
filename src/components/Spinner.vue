<template>
  <b-container>
    <b-row align-v="center">
      <b-col cols="3" style="text-align:right;">
        <b-img class="arrow" src="https://imgur.com/oNoIaSd.png" fluid-grow  />
      </b-col>
      <b-col cols="6">
        <b-img v-bind:class="{ rotating: this.$store.state.bet.isRunning}" src="https://imgur.com/35na1zE.png" fluid-grow />

      </b-col>
      <b-col cols="3">
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
export default {
  name: "Spinner"
}
</script>
<style scoped>
.arrow{
  max-height:100px;
  max-width:100px;

}
/*Handles all different browsers  */
@keyframes rotating
    {
    from
        {
        transform: rotate(0deg);
        -webkit-transform: rotate(0deg);
        }
    to
        {
        transform: rotate(360deg);
        -webkit-transform: rotate(360deg);
        }
    }
@-webkit-keyframes rotating
    {
    from
        {
        transform: rotate(0deg);
        -webkit-transform: rotate(0deg);
        }
    to
        {
        transform: rotate(360deg);
        -webkit-transform: rotate(360deg);
        }
    }
.rotating
    {
    max-height:400px;
    max-width:400px;
    -webkit-animation: rotating 2s linear;
    animation: rotating 2s linear infinite;
    }

</style>
