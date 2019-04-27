pragma solidity >=0.4.25 <0.6.0;

import { Owned } from "./Owned.sol";

/// @title Defines structures to work with Participants.
/// @dev This is a supporting contract for Event.

contract Hostable is Owned
{
    struct Participant {
        bool booked;  // if true, that person already voted
        bool arrived;  // if true, that person already voted
    }

    mapping(address => Participant) public participants;
    
    address[] public participantAddresses;

    function _saveParticipant(address participant) internal {
        participants[participant] = Participant({ booked: true, arrived: false });
    }
}
