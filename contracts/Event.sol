pragma solidity >=0.4.25 <0.6.0;

import { Owned } from "./libs/Owned.sol";
import { FiatContract } from "./libs/FiatContract.sol";
import { Bookable } from "./libs/Bookable.sol";

/// @title A contract for event booking between an organizer and multiple participants
/// @author Ruben B. Meseguer
/// @notice You can use this contract for only the most basic simulation
/// @dev All function calls are currently implemented without side effects

contract Event is Owned, Bookable
{
    address InstanceOwner;
    uint256 public cost;
    uint limit;
    // implemenet cost
    FiatContract public price;
    event NewPayment(address sender, uint256 amount);
    
    // Create contract, it costs money to the owner
    constructor(uint256 eventCost) public {
        InstanceOwner = msg.sender;
        price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);        
        cost = eventCost;
    }

    // returns $5.00 USD in ETH wei.
    function getFiatCost() internal view returns (uint256) {
        // returns $0.01 ETH wei
        uint256 ethCent = price.USD(0);
        // $0.01 * 500 = $5.0
        return ethCent * (cost * 100);
    } 
}
