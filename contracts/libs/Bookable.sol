pragma solidity >=0.4.25 <0.6.0;

import { Hostable } from "./Hostable.sol";
import { Priceable } from "./Priceable.sol";

/// @title Contains functionality to book an event
/// @notice Allow users to book, cancel and get a refund for an item.

contract Bookable is Hostable, Priceable
{
    function _refund(address participant) internal;
    function _refundAll() internal view;

    event NewBooking();

    uint public cost;
    uint public limit;
    
    // Create contract, it costs money to the owner
    constructor(uint256 eventCost) public {
        cost = eventCost;
    }

    /// @notice Book a place in the event. Fundation will get 1% of every booking.
    function book() public payable {
        // Don't overbook
        require (participantIndex.length < limit);
        // Pay amount required
        require(_verifyFiatCost(cost));

        _saveParticipant(msg.sender);
        emit NewBooking();
    }
    
    /// @notice Cancel booking, can only get a full refund if less than 50% of the people have confirmed their attendance.
    /// @dev We're still not set in the refunding conditions.
    function cancel() public payable {
        require(participants[msg.sender].booked == true);
        _refund(msg.sender);
        _removeParticipant(msg.sender);
    }

    /// @notice Confirms the user attended the event and sends the money to the organizer.
    /// @dev We're still not sure if sending the money needs to wait a few minutes.
 
    function confirmAttendance() public payable {
        Participant memory participant = participants[msg.sender];
        require(participant.booked && !participant.arrived);
        participant.arrived = true;
    }

    // Refund all the money. Owner loses deposited money, which is distributed among participants
    function cancelEvent() public view onlyOwner {
        _refundAll();        
    }
    
}
