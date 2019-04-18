<template>
  <b-container>
    <b-row align-v="center">
      <b-col cols="3" style="text-align:right;">
        <b-img class="arrow" src="http://pluspng.com/img-png/arrow-png-arrow-png-pic-png-image-1332.png" fluid-grow />
      </b-col>
      <b-col cols="6">
        <b-img class="rotating" src="https://i.pinimg.com/originals/08/d9/94/08d994855764489e12346d6e899a2277.png" fluid-grow />
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
        -o-transform: rotate(0deg);
        -ms-transform: rotate(0deg);
        -moz-transform: rotate(0deg);
        -webkit-transform: rotate(0deg);
        }
    to
        {
        transform: rotate(360deg);
        -o-transform: rotate(360deg);
        -ms-transform: rotate(360deg);
        -moz-transform: rotate(360deg);
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
    -webkit-animation: rotating 2s linear infinite;
    -moz-animation: rotating 2s linear infinite;
    -ms-animation: rotating 2s linear infinite;
    -o-animation: rotating 2s linear infinite;
    animation: rotating 2s linear infinite;
    }

/* .image {

    width: 280px;
    height:280px;

  } */
/* .rotating {
  transition: transform 1s ease-in-out;
}
.rotating:hover {
  transform: rotateZ(360deg);
} */


    /* .buildSpinClasses(1); */

/* .buildSpinClasses(@counter) when (@counter <= @sectorCount) {
  .buildSpinClasses((@counter + 1));
  &.sector-@{counter} {
    animation: ~"spin-@{counter}" ~"@{spinTime}s" cubic-bezier(0.4, 0.2, 0, 1.0) 1s 1;
    animation-fill-mode: forwards;
  }

} */

/*.buildSpinKeyframes(@counter) when (@counter <= @sectorCount) {
  .buildSpinKeyframes((@counter + 1));    // next iteration

  @sector: (360/@sectorCount)*@counter;
  @keyframes ~"spin-@{counter}" {
    100% {
      transform:rotate( (360deg*@spinTime*3)-@sector );
    }
  }
}
.buildSpinKeyframes(1); */
</style>
