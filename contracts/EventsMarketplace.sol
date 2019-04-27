pragma solidity >=0.4.25 <0.6.0;

import { Owned } from "./Owned.sol";

contract FiatContract {
  function ETH(uint _id) public view returns (uint256);
  function USD(uint _id) public view returns (uint256);
  function EUR(uint _id) public view returns (uint256);
  function GBP(uint _id) public view returns (uint256);
  function updatedAt(uint _id) public view returns (uint);
}

/// @title A contract for event booking between an organizer and multiple participants
/// @author Ruben B. Meseguer
/// @notice You can use this contract for only the most basic simulation
/// @dev All function calls are currently implemented without side effects

contract EventBooking is Owned
{
   // stop implemeneting

    address InstanceOwner;
    uint cost;
    uint limit;

    // Create contract, it costs money to the owner
    constructor() public payable {
        price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);        
        InstanceOwner = msg.sender;
        cost = 5;
    }

    // implemenet cost
    FiatContract public price;
    event NewPayment(address sender, uint256 amount);

    // returns $5.00 USD in ETH wei.
    function getFiatCost() internal view returns (uint256) {
        // returns $0.01 ETH wei
        uint256 ethCent = price.USD(0);
        // $0.01 * 500 = $5.0
        return ethCent * (cost * 100);
    }

 

    struct Participant {
        bool booked;  // if true, that person already voted
        bool arrived;  // if true, that person already voted
    }

    // This declares a state variable that
    // stores a `Participant` struct for each possible address.
    mapping(address => Participant) public participants;
    address[] public participantAddresses;

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
