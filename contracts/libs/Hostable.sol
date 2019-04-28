pragma solidity >=0.4.25 <0.6.0;

import { Owned } from "./Owned.sol";

/// @title Defines structures to work with Participants.
/// @dev This is a supporting contract for Event.

contract Hostable is Owned
{
    struct Participant {
        uint index;
        bool booked;  // if true, that person already voted
        bool arrived;  // if true, that person already voted
    }

    mapping(address => Participant) public participants;
    
    address[] public participantIndex;

    function _saveParticipant(address participantAddress) internal {
        require(_isParticipant(participantAddress)); 
        
        participants[participantAddress].booked = true;
        participants[participantAddress].index = participantIndex.push(participantAddress) - 1;
        // return participantIndex.length - 1;
    }

    function _removeParticipant(address participantAddress) internal {
        require(_isParticipant(participantAddress));
        // Remove them from lookup table
        uint rowToDelete = participants[participantAddress].index;
        // Get last row address
        address keyToMove = participantIndex[participantIndex.length - 1];
        // Set it to the new position
        participantIndex[rowToDelete] = keyToMove;
        // And fix its index
        participants[keyToMove].index = rowToDelete; 
        // The other value will be lost since it now isnt part of the lookup table
        participantIndex.length--;
    }

    function getTotalArrived() public view returns (uint256) {
        uint256 totalArrived;
        for (uint i = 0; i < participantIndex.length; i++) {
            Participant memory participant = participants[participantIndex[i]];
            
            if(participant.arrived) {
                totalArrived++;
            }
        }
        return totalArrived;
    }

    function _isParticipant(address participantAddress) public view returns(bool isIndeed) {
        if(participantIndex.length == 0) { 
            return false;
        }
        return (participantIndex[participants[participantAddress].index] == participantAddress);
    }
}
