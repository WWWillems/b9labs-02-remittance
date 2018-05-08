pragma solidity ^0.4.23;

contract Owned {
    address private owner;

	modifier only_owner {
	    require(msg.sender == owner);
	    _;
	}

	event LogNewOwner(address indexed old, address indexed current);

    // Constructor
    constructor()
    public {
        owner = msg.sender;
    }

    function setOwner(address _new)
    only_owner
    public {
        require(_new != owner);

        owner = _new;

        emit LogNewOwner(owner, _new);
    }
}
