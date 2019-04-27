const EventBooking = artifacts.require("EventBooking");
// const Owned = artifacts.require("Owned");

module.exports = function(deployer) {
  // deployer.deploy(Owned);
  // deployer.link(EventBooking, Owned);
  deployer.deploy(EventBooking);
};
