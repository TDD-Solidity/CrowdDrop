const CrowdDropCore = artifacts.require("CrowdDropCore");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("CrowdDropCore", function (/* accounts */) {
  it("should assert true", async function () {
    await CrowdDropCore.deployed();
    return assert.isTrue(true);
  });
});
