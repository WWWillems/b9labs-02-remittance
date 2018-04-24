var Remittance = artifacts.require("./Remittance.sol");
var utils = require('web3-utils');

var recipient = "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c";
var puzzle = utils.soliditySha3("zever", recipient);
console.log(puzzle)

// TODO: Update deploy
module.exports = function(deployer, network, accounts) {
  deployer.deploy(
      Remittance,
      { from: accounts[0], gas:1000000 });
};
