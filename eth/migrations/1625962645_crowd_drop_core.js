const CrowdDropCore_Eth = artifacts.require("CrowdDropCore_Eth");

module.exports = function (deployer) {
  deployer.deploy(CrowdDropCore_Eth);
};
