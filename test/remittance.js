var Remittance = artifacts.require('./Remittance.sol');

contract('Remittance', function(accounts) {

  var contractInstance;
  var owner;

  beforeEach('Setup contract for each test', async function() {
    contractInstance = await Remittance.new({from: accounts[0]});

    owner = accounts[0];
  });

  it("should be owned by the creator", async function(){
    var _owner = await contractInstance.owner();
    assert.strictEqual(owner, _owner, "Contract owner doesn't match contract creator.");
  });
});
