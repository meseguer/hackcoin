pragma solidity >=0.4.25 <0.6.0;

/// @title A contract for event booking between an organizer and multiple participants
/// @author Ruben B. Meseguer
/// @notice You can use this contract for only the most basic simulation
/// @dev All function calls are currently implemented without side effects

contract Hostable
{
    struct Participant {
        bool booked;  // if true, that person already voted
        bool arrived;  // if true, that person already voted
    }
    mapping(address => Participant) public participants;
    address[] public participantAddresses;

}
