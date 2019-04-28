// const Event = artifacts.require("Event");
// const Refundable = artifacts.require("Refundable");
// const Owned = artifacts.require("Owned");
const Hostable = artifacts.require("Hostable");

module.exports = function(deployer) {
  // deployer.deploy(Owned);
  // deployer.link(EventBooking, Owned);
  // deployer.deploy(Event);
  deployer.deploy(Hostable);
};
