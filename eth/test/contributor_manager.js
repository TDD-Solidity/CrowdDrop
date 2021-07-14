const ContributorManager = artifacts.require("ContributorManager");

contract("ContributorManager", function (/* accounts */) {

  it("should assert true", async function () {
    await ContributorManager.deployed();
    return assert.isTrue(true);
  });

});
