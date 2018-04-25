pragma solidity ^0.4.23;

// CHECK - EFFECS - INTEGRATIONS

contract Remittance {

    address public owner;

    struct RemittanceStruct {
        address owner;
        uint amount;
        bytes32 puzzle;
        bool isPuzzleSolved;
        bool isInitialised;
    }

    mapping(address => RemittanceStruct) public remittances;

    event LogCreation(RemittanceStruct indexed remittance);
    event LogKill(address indexed by);
    event LogPuzzleSolve(RemittanceStruct indexed remittance);
    event LogWithdrawal(RemittanceStruct indexed remittance);

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
        require(msg.sender != address(0x0));
        require(_recipient != address(0x0));
        require(_password != keccak256(''));

        RemittanceStruct memory newRemittance;
        newRemittance.owner = msg.sender;
        newRemittance.amount = msg.value;
        newRemittance.puzzle = _password;
        newRemittance.isInitialised = true;

        remittances[_recipient] = newRemittance;

        emit LogCreation(newRemittance);

        return true;
    }

    function submitPassword(string _password)
    public
    returns (bool success)
    {
        RemittanceStruct storage remittance = remittances[msg.sender];
        require(remittance.isInitialised);
        require(remittance.amount > 0);
        require(remittance.puzzle != keccak256(''));
        require(!remittance.isPuzzleSolved);

        // Compare input with puzzle, attempt to solve it
        //require(_password.length > 0);
        require(hashVal(_password) == remittance.puzzle);

        remittance.isPuzzleSolved = true;

        // Unlock funds from owner->recipient
        uint amount = remittance.amount;
        delete remittances[msg.sender];

        emit LogPuzzleSolve(remittance);

        // Start withdrawal
        emit LogWithdrawal(remittance);

        msg.sender.transfer(amount);

        return true;
    }

    // Helper function, handy when using Remix
    function displayPuzzle()
    public
    view
    returns (bytes32 puzzle)
    {
        RemittanceStruct storage remittance = remittances[msg.sender];
        return remittance.puzzle;
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
