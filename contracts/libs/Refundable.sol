pragma solidity >=0.4.25 <0.6.0;

import { Bookable } from "./Bookable.sol";

/// @title A supporting contract containing functionality for refunding userss
/// @author Ruben B. Meseguer
/// @notice Allow users to obtain a refund.
/// @dev All function calls are currently implemented without side effects

contract Refundable is Bookable
{

    function _refund() internal view {
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

    function _refundAll() internal view {

    }

    
    /// @notice Confirms the user attended the event and sends the money to the organizer.
    /// @dev We're still not sure if sending the money needs to wait a few minutes.
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
