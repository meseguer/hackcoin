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

    /// @notice Book a place in the event. 75% refund if you don't attend.
    /// @dev The Alexandr N. Tetearing algorithm could increase precision
    /// @param rings The number of rings from dendrochronological sample
    /// @return Encoded QR CODE. It'll be used by the organizers to configm your attendance.
    
    // Fundation will get 1% of every booking.
    function book() public payable {
        // Don't overbook
        require (participantAddresses.length < limit);
        // Pay amount required
        require (msg.value >= getFiatCost());
        // Save them as participants
        participants[msg.sender] = Participant({booked: true, arrived: false});
        // emit NewParticipant(msg.sender);
    }

    function cancel() public payable {
        // Check user has booked a place
        require(participants[msg.sender].booked == true);
        // Remove them from array of participants
        // Change their status to cancel
        uint amountToRefund;
        if(_canFullRefund()) {
            // Refund 100 percent of the ticket
            amountToRefund = getFiatCost() * 7500 / 10000;
        } else {
            // Refund 75 percent of the ticket
            amountToRefund = getFiatCost() * 7500 / 10000;
        }
        require(msg.sender.send(amountToRefund));
    }

    // After confirming, users will have 5 minutes to refund 
    function confirmAttendance() public payable {
        Participant memory participant = participants[msg.sender];
        require(participant.booked && !participant.arrived);
        participant.arrived = true;
    }

    // // Refund all the money. Owner loses deposited money, which is distributed among participants
    // function cancelEvent() public onlyOwner {
        
    // }

    function _canFullRefund() internal view returns (bool) {
        // We know the length of the array
        uint arrayLength = participantAddresses.length;
        // totalValue auto init to 0
        uint totalArrived;
        for (uint i=0; i < arrayLength; i++) {
            address participantAddress = participantAddresses[i];
            Participant memory participant = participants[participantAddress];
            
            if(participant.arrived) {
                totalArrived++;
            }
        }
        // Check if less than 50 percent of participants have gone
        return (totalArrived <= (arrayLength / 2));
    }
}
