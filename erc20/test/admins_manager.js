const AdminsManager = artifacts.require("AdminsManager");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("AdminsManager", function (/* accounts */) {
  it("should assert true", async function () {
    await AdminsManager.deployed();
    return assert.isTrue(true);
  });
});
