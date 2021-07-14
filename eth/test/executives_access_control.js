const ExecutivesAccessControl = artifacts.require("ExecutivesAccessControl");

contract("ExecutivesAccessControl", function (/* accounts */) {
  
  it("should assert true", async function () {
    await ExecutivesAccessControl.deployed();
    return assert.isTrue(true);
  });
  
});
