const Event = artifacts.require("Event");
// const Owned = artifacts.require("Owned");

module.exports = function(deployer) {
  // deployer.deploy(Owned);
  // deployer.link(EventBooking, Owned);
  deployer.deploy(Event, 10);
};
