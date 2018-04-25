pragma solidity ^0.4.23;

contract Owned {
    address public owner = msg.sender;

	modifier only_owner {
	    require(msg.sender == owner);
	    _;
	}

	event NewOwner(address indexed old, address indexed current);

    function setOwner(address _new)
    only_owner
    public {
        emit NewOwner(owner, _new);
        owner = _new;
    }

	// Constructor
    constructor()
    public {
        setOwner(msg.sender);
    }
}

contract Remittance is Owned {

    struct RemittanceStruct {
        address owner;
        uint amount;
        bytes32 puzzle;
    }

    mapping(address => RemittanceStruct) public remittances;

    event LogCreation(RemittanceStruct indexed remittance);
    event LogKill(address indexed by);
    event LogPuzzleSolve(RemittanceStruct indexed remittance);
    event LogWithdrawal(address indexed from, address indexed to, uint amount);

    // Constructor
    constructor()
    public {
        owner = msg.sender;
    }

    // Fallback function
    function()
    public{
        revert();
    }

    function createRemittance(bytes32 _password, address _recipient)
    public
    payable
    returns (bool success)
    {
        require(msg.value > 0);
        require(_recipient != address(0x0));
        require(_password != bytes32(0));

        // Make sure we're not overwriting an existing Remittance
        require(remittances[_recipient].puzzle == bytes32(0));

        RemittanceStruct memory newRemittance;
        newRemittance.owner = msg.sender;
        newRemittance.amount = msg.value;
        newRemittance.puzzle = _password;

        remittances[_recipient] = newRemittance;

        emit LogCreation(newRemittance);

        return true;
    }

    function submitPassword(string _puzzle)
    public
    returns (bool success)
    {
        RemittanceStruct storage remittance = remittances[msg.sender];
        require(remittance.amount > 0);
        require(remittance.puzzle != bytes32(0));

        // Compare input with puzzle, attempt to solve it
        require(hashVal(_puzzle) == remittance.puzzle);

        // Unlock funds from owner->recipient
        uint amount = remittance.amount;
        delete remittances[msg.sender];

        emit LogPuzzleSolve(remittance);

        // Start withdrawal
        emit LogWithdrawal(remittance.owner, msg.sender, remittance.amount);

        msg.sender.transfer(amount);

        return true;
    }

    // Lock-in hash function:
    // If your function is declared as view or pure you can call it from javascript without paying gas,
    // and it should return   the exact same result that when it is called from inside the contract
    function hashVal(string val) public view returns (bytes32) {
        return keccak256(val, msg.sender);
    }

    function kill()
    public {
        require(msg.sender == owner);

        emit LogKill(msg.sender);

        selfdestruct(owner);
    }
}
