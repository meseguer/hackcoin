const Event = artifacts.require("Event");
const VerifierContract = artifacts.require("VerifierContract");

module.exports = function(deployer) {
  deployer.deploy(Event, 10);
  deployer.deploy(VerifierContract);
};
