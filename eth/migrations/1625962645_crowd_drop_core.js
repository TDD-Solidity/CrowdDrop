const CrowdDropCore = artifacts.require("CrowdDropCore");

module.exports = function (deployer) {
  deployer.deploy(CrowdDropCore);
};
