const CrowdDropBase = artifacts.require("CrowdDropBase");

contract("CrowdDropBase", function (/* accounts */) {
  
  it("should assert true", async function () {
    await CrowdDropBase.deployed();
    return assert.isTrue(true);
  });

});
