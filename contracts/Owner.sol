pragma solidity ^0.4.23;

contract Owned {
    address public owner;

	modifier only_owner {
	    require(msg.sender == owner);
	    _;
	}

	event LogNewOwner(address indexed old, address indexed current);

    function setOwner(address _new)
    only_owner
    public {
        emit LogNewOwner(owner, _new);
        owner = _new;
    }

	// Constructor
    constructor()
    public {
        owner = msg.sender;

        setOwner(msg.sender);
    }
}
