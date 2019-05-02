// const Event = artifacts.require("Event");
// const Refundable = artifacts.require("Refundable");
// const Owned = artifacts.require("Owned");
const Refundable = artifacts.require("Refundable");

module.exports = function(deployer) {
  // deployer.deploy(Owned);
  // deployer.link(EventBooking, Owned);
  // deployer.deploy(Event);
  deployer.deploy(Refundable, 10);
};
