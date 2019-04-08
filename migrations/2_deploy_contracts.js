var MyContract = artifacts.require("./MyContract.sol");
var Betting = artifacts.require("./Betting.sol");

module.exports = function(deployer) {
  deployer.deploy(MyContract);
  deployer.deploy(Betting, 100);
};
