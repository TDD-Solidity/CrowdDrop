const CrowdDropCore = artifacts.require("CrowdDropCore");

contract("CrowdDropCore", function (/* accounts */) {
  
  it("should assert true", async function () {
    await CrowdDropCore.deployed();
    return assert.isTrue(true);
  });
  
});
