pragma solidity 0.4.23;

contract Ownable {
    address public owner;

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
        require(_new != address(0));

        emit LogNewOwner(owner, _new);

        owner = _new;
    }
}
