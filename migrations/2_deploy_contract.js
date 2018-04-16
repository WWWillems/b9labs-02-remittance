var Remittance = artifacts.require("./Remittance.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(
      Remittance,
      { from: accounts[0], gas:1000000});
};
