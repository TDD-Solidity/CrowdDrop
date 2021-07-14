const AdminsManager = artifacts.require("AdminsManager");

contract("AdminsManager", function (/* accounts */) {
  
  it("should assert true", async function () {
    await AdminsManager.deployed();
    return assert.isTrue(true);
  });

});
