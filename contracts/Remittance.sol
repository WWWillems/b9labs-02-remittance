pragma solidity ^0.4.18;

contract Remittance {
    address public owner;

    function Remittance() public {
        owner = msg.sender;
    }
}
