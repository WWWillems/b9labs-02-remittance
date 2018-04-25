var Remittance = artifacts.require("./Remittance.sol");
var utils = require('web3-utils');

var recipient = "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c";
var password = "zever";//utils.soliditySha3("zever");//"zever";
var puzzle = utils.soliditySha3(password, recipient);
console.log('PUZZLE:' , puzzle)


//"0x812aa39ecbcf597a29cc1fca96d7ac9f134baf73576f5d5682a4a8a27de4c2b7", "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c"

// TODO: Update deploy
module.exports = function(deployer, network, accounts) {
  deployer.deploy(
      Remittance,
      { from: accounts[0], gas:1000000 });
};
