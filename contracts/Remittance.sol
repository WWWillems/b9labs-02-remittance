pragma solidity ^0.4.18;

// CHECK - EFFECS - INTEGRATIONS

contract Remittance {
    address public owner;
    bytes32 public puzzle;
    bool public isPuzzleSolved;

    mapping(address => uint) public balances;

    event LogCreation(address indexed by, uint amount, bytes32 puzzle);
    event LogKill(address indexed by);
    event LogPuzzleSolve(address indexed by, uint amount);
    event LogWithdrawal(address indexed from, address indexed to, uint amount);

    // Constructor
    function Remittance(bytes32 _puzzle)
    payable
    public {
        require(msg.value > 0);
        require(msg.sender != address(0x0));
        require(_puzzle != keccak256(''));
        require(msg.data.length == 36);

        owner = msg.sender;
        balances[owner] = msg.value;
        puzzle = _puzzle;

        emit LogCreation(msg.sender, msg.value, puzzle);
    }

    // Fallback function
    function()
    public{
        revert();
    }

    function submitPasswords(string _puzzleblock1, string _puzzleblock2)
    public
    {
        require(!isPuzzleSolved);

        require(bytes(_puzzleblock1).length > 0);
        require(bytes(_puzzleblock2).length > 0);

        // Compare input with puzzle, attempt to solve it
        if(keccak256(_puzzleblock1, _puzzleblock2) != puzzle) revert();

        isPuzzleSolved = true;

        uint amount = balances[owner];

        balances[owner] = 0;
        balances[msg.sender] = amount;

        emit LogPuzzleSolve(msg.sender, amount);
    }

    // Recipients can use this function to withdraw their part of the payments
    function withdrawFunds()
    public
    returns (bool success){
        require(isPuzzleSolved);

        uint amount = balances[msg.sender];
        require(amount > 0);

        // Remember to zero the pending refund before
        // sending to prevent re-entrancy attacks
        balances[msg.sender] = 0;
        emit LogWithdrawal(msg.sender, msg.sender, amount);

        msg.sender.transfer(amount);

        return true;
    }

    function kill()
    public {
        require(msg.sender == owner);

        emit LogKill(msg.sender);

        selfdestruct(owner);
    }
}
