pragma solidity >=0.4.25 <0.6.0;

contract WorkbenchBase {
    event WorkbenchContractCreated(string applicationName, string workflowName, address originatingAddress);
    event WorkbenchContractUpdated(string applicationName, string workflowName, string action, address originatingAddress);

    string internal ApplicationName;
    string internal WorkflowName;

    constructor (string memory applicationName,  string memory workflowName) internal {
        ApplicationName = applicationName;
        WorkflowName = workflowName;
    }

    function ContractCreated() internal {
        emit WorkbenchContractCreated(ApplicationName, WorkflowName, msg.sender);
    }

    function ContractUpdated(string memory action) internal {
        emit WorkbenchContractUpdated(ApplicationName, WorkflowName, action, msg.sender);
    }
}

contract SimpleMarketplace is WorkbenchBase('SimpleMarketplace', 'SimpleMarketplace')
{
    enum StateType { 
      ItemAvailable,
      OfferPlaced,
      Accepted
    }

    address public InstanceOwner;
    string public Description;
    int public AskingPrice;
    StateType public State;

    address public InstanceBuyer;
    int public OfferPrice;

    constructor(string memory description, int price) public
    {
        InstanceOwner = msg.sender;
        AskingPrice = price;
        Description = description;
        State = StateType.ItemAvailable;
        ContractCreated();
    }

    function MakeOffer(int offerPrice) public
    {
        if (offerPrice == 0)
        {
            revert();
        }

        if (State != StateType.ItemAvailable)
        {
            revert();
        }
        
        if (InstanceOwner == msg.sender)
        {
            revert();
        }

        InstanceBuyer = msg.sender;
        OfferPrice = offerPrice;
        State = StateType.OfferPlaced;
        ContractUpdated('MakeOffer');
    }

    function Reject() public
    {
        if ( State != StateType.OfferPlaced )
        {
            revert();
        }

        if (InstanceOwner != msg.sender)
        {
            revert();
        }

        InstanceBuyer = address(0x0);
        State = StateType.ItemAvailable;
        ContractUpdated('Reject');
    }

    function AcceptOffer() public
    {
        if ( msg.sender != InstanceOwner )
        {
            revert();
        }

        State = StateType.Accepted;
        ContractUpdated('AcceptOffer');
    }
}
