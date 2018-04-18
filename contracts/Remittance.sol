pragma solidity ^0.4.18;

// CHECK - EFFECS - INTEGRATIONS

contract Remittance {
    address public owner;
    bytes32 public puzzle;
    bool public isPuzzleSolved;

    mapping(address => uint) public balances;

    event LogCreation(address indexed by, uint amount);
    event LogKill(address indexed by);
    event LogPuzzleSolve(address indexed by);
    event LogWithdrawal(address indexed from, address indexed to, uint amount);

    // Constructor
    function Remittance(string puzzleblock1, string puzzleblock2)
    payable
    public {
        require(msg.value > 0);
        require(msg.sender != address(0x0));

        require(bytes(puzzleblock1).length > 0);
        require(bytes(puzzleblock2).length > 0);
        require(!compareStrings(puzzleblock1, puzzleblock2));

        owner = msg.sender;
        balances[owner] = msg.value;
        puzzle = keccak256(puzzleblock1, puzzleblock2);

        emit LogCreation(msg.sender, msg.value);
    }

    // Fallback function
    function()
    public{
        revert();
    }

    function submitPasswords(string _puzzleblock1, string _puzzleblock2)
    public
    {
        assert(!isPuzzleSolved);
        require(msg.sender != address(0x0));

        require(bytes(_puzzleblock1).length > 0);
        require(bytes(_puzzleblock2).length > 0);
        require(!compareStrings(_puzzleblock1, _puzzleblock2));

        // Compare input with puzzle, attempt to solve it
        if(keccak256(_puzzleblock1, _puzzleblock2) == puzzle){
            isPuzzleSolved = true;

            uint amount = balances[owner];

            balances[owner] = 0;
            balances[msg.sender] = amount;

            emit LogPuzzleSolve(msg.sender);
        }
    }

    // Recipients can use this function to withdraw their part of the payments
    function withdrawFunds()
    public
    returns (bool success){
        assert(isPuzzleSolved);

        uint amount = balances[msg.sender];
        require(amount > 0);

        // Remember to zero the pending refund before
        // sending to prevent re-entrancy attacks
        balances[msg.sender] = 0;
        emit LogWithdrawal(msg.sender, msg.sender, amount);

        msg.sender.transfer(amount);

        return true;
    }

    function compareStrings (string a, string b)
    private
    view
    returns (bool){
        return keccak256(a) == keccak256(b);
    }

    function kill()
    public {
        require(msg.sender == owner);

        emit LogKill(msg.sender);

        selfdestruct(owner);
    }
}
