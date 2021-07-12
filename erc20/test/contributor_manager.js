const ContributorManager = artifacts.require("ContributorManager");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("ContributorManager", function (/* accounts */) {
  it("should assert true", async function () {
    await ContributorManager.deployed();
    return assert.isTrue(true);
  });
});
