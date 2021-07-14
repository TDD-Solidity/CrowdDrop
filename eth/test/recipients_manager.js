const RecipientsManager = artifacts.require("RecipientsManager");

contract("RecipientsManager", function (/* accounts */) {
  
  it("should assert true", async function () {
    await RecipientsManager.deployed();
    return assert.isTrue(true);
  });
  
});
