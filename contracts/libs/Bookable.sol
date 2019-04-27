pragma solidity >=0.4.25 <0.6.0;

import { Hostable } from "./Hostable.sol";

/// @title A supporting contract for event booking
/// @author Ruben B. Meseguer
/// @notice Allow users to book, cancel and get a refund for an item.
/// @dev All function calls are currently implemented without side effects

contract Bookable is Hostable
{
    function _getFiatCost() internal view returns (uint256);
    function _refund(address participant) internal view returns (uint256);
    function _refundAll() internal view returns (uint256);

    event NewBooking();

    uint256 public cost;
    uint limit;
    
    // Create contract, it costs money to the owner
    constructor(uint256 eventCost) public {
        cost = eventCost;
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
        _saveParticipant(msg.sender);
        emit NewBooking();
    }
    
    /// @notice Cancel booking, can only get a full refund if less than 50% of the people have confirmed their attendance.
    /// @dev We're still not set in the refunding conditions.

    function cancel() public payable {
        // Check user has booked a place
        require(participants[msg.sender].booked == true);
        // Remove them from array of participants
        // Change their status to cancel
        _refund(msg.sender);
    }

    /// @notice Confirms the user attended the event and sends the money to the organizer.
    /// @dev We're still not sure if sending the money needs to wait a few minutes.
 
    function confirmAttendance() public payable {
        Participant memory participant = participants[msg.sender];
        require(participant.booked && !participant.arrived);
        participant.arrived = true;
    }

    // // Refund all the money. Owner loses deposited money, which is distributed among participants
    function cancelEvent() public onlyOwner {
        _refundAll();        
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
