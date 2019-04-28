pragma solidity >=0.4.25 <0.6.0;

import { FiatContract } from "./FiatContract.sol";

/// @title A contract for event booking between an organizer and multiple participants
/// @author Ruben B. Meseguer
/// @notice You can use this contract for only the most basic simulation
/// @dev All function calls are currently implemented without side effects

contract Priceable
{
    // implemenet cost
    FiatContract public price;
    event NewPayment(address sender, uint256 amount);
    
    // Create contract, it costs money to the owner
    constructor() public {
        price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);        
    }

    function _verifyFiatCost(uint fiatCost) internal view returns (bool) {
        return msg.value >= _getEtherCost(fiatCost);
    }

    // returns $5.00 USD in ETH wei.
    function _getEtherCost(uint256 fiatCost) internal view returns (uint256) {
        // returns $0.01 ETH wei
        uint256 ethCent = price.USD(0);
        // $0.01 * 500 = $5.0
        return ethCent * (fiatCost * 100);
    }
}
