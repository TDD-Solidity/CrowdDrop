const RecipientsManager = artifacts.require("RecipientsManager");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("RecipientsManager", function (/* accounts */) {
  it("should assert true", async function () {
    await RecipientsManager.deployed();
    return assert.isTrue(true);
  });
});
