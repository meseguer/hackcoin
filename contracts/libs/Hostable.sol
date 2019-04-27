pragma solidity >=0.4.25 <0.6.0;

/// @title A contract defining the structures for working with Participants.
/// @author Ruben B. Meseguer
/// @dev This is a supporting contract for Event.

contract Hostable
{
    struct Participant {
        bool booked;  // if true, that person already voted
        bool arrived;  // if true, that person already voted
    }
    mapping(address => Participant) public participants;
    address[] public participantAddresses;

}
