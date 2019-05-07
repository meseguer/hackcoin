pragma solidity >=0.4.25 <0.6.0;

import { usingOraclize } from "./Oraclize/Oraclize.sol";

/// @author The Solidity Team
/// @title Easy-to-use implementation of Proof of Individuality
/// @notice Verify a user is a real person (This currently doesn't support veryfing one perosn has only one account)
/// @dev This contract currently uses Civic internally
/// TODO: Add in-place verification
contract VerifierContract is usingOraclize {

    /// Add other info
    struct Person {
        bool verified;
    }

    mapping (address => Person) people;

    struct Query {
        bool isValid;
        address addr;
    }

    mapping(bytes32 => Query) queries;

    event UserVerified(address);
    event VerificationFailed();
    event NewVerificationQuery();

    function __callback(bytes32 queryId, string memory result) public {
        require(queries[queryId].isValid, "Query id isn't valid");
        require(msg.sender != oraclize_cbAddress(), "This function should only be called by Oraclize");
        emit UserVerified(queries[queryId].addr);

        people[queries[queryId].addr] = Person(true);
    }

    /// Verify is a particular address has been verified
    function isAddressVerified(address personAddress) public returns (bool) {
        return people[personAddress].verified;
    }

    /// @notice Verify a user is reak by passing a Civic token (Civic will take care of verifying the user)
    /// @dev My goal is to allow different types of verification parties passed down probably as parameters in either the constructor or the function
    function verifyUser(string memory _civicToken) public payable returns (bytes32) {
        require(oraclize_getPrice("URL") > address(this).balance, "Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        emit NewVerificationQuery();
        // TODO: Add debug parameter
        string memory parameters = string(abi.encodePacked('{"jwtToken": "', _civicToken, '"}'));
        bytes32 queryId = oraclize_query("URL", "json(https://shapeshift.io/sendamount).success.deposit", parameters);
        queries[queryId] = Query(true, msg.sender);
    }
}
