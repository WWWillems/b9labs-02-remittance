pragma solidity ^0.4.18;

// CHECK - EFFECS - INTEGRATIONS

contract Remittance {

    address public owner;
    bytes32 public puzzle;
    bool public isPuzzleSolved;
    address public recipient;


    mapping(address => uint) public balances;

    event LogCreation(address indexed by, address indexed recipient, uint amount, bytes32 puzzle);
    event LogKill(address indexed by);
    event LogPuzzleSolve(address indexed by, uint amount, bytes32 puzzle);
    event LogWithdrawal(address indexed from, address indexed to, uint amount);

    // Constructor
    function Remittance(bytes32 _password, address _recipient)
    payable
    public {
        require(msg.value > 0);
        require(msg.sender != address(0x0));
        require(_recipient != address(0x0));
        require(_password != keccak256(''));

        owner = msg.sender;
        balances[owner] = msg.value;
        puzzle = _password;
        recipient = _recipient;

        emit LogCreation(msg.sender, recipient, msg.value, puzzle);
    }

    // Fallback function
    function()
    public{
        revert();
    }

    function submitPassword(bytes32 _password)
    public
    returns (bool success)
    {
        require(msg.sender == recipient);
        require(!isPuzzleSolved);
        require(_password.length > 0);

        // Compare input with puzzle, attempt to solve it
        require(hashVal(_password) == puzzle);

        isPuzzleSolved = true;

        // Unlock funds from owner->recipient
        uint amount = balances[owner];
        balances[owner] = 0;
        emit LogPuzzleSolve(msg.sender, amount, puzzle);

        // Start withdrawal
        require(amount > 0);

        emit LogWithdrawal(owner, msg.sender, amount);

        msg.sender.transfer(amount);

        return true;
    }

    // Lock-in hash function:
    // If your function is declared as view or pure you can call it from javascript without paying gas,
    // and it should return   the exact same result that when it is called from inside the contract
    function hashVal(bytes32 val) public view returns (bytes32) {
        return keccak256(val, msg.sender);
    }

    function kill()
    public {
        require(msg.sender == owner);

        emit LogKill(msg.sender);

        selfdestruct(owner);
    }
}
