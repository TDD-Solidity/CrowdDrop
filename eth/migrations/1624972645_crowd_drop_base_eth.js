const CrowdDropBase_Eth = artifacts.require("CrowdDropBase_Eth");

module.exports = function (deployer) {
  deployer.deploy(CrowdDropBase_Eth);
};
