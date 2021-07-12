const CrowdDropCore_ERC20 = artifacts.require("CrowdDropCore_ERC20");

let crowdDropCore_ERC20;

beforeEach(async () => {
  
   crowdDropCore_ERC20 = await CrowdDropCore_ERC20.deployed();
})

contract("CrowdDropCore_ERC20", function ( accounts ) {
  it("should assert true", async function () {

    return assert.isTrue(true);
  });
});
