// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnBank {
    mapping(address => uint256) public balances;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Deposit Ether into the bank
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Vulnerable withdraw function (Re-Entrancy)
    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient funds");
        (bool sent, ) = msg.sender.call{value: _amount}(""); // Dangerous
        require(sent, "Failed to send Ether");

        balances[msg.sender] -= _amount;
    }

    // Vulnerable admin-only function without proper access control
    function kill() public {
        selfdestruct(payable(msg.sender)); // Anyone can call
    }

    // Vulnerable to integer underflow (if compiled with ^0.7.0 or older)
    function underflow() public pure returns (uint256) {
        uint256 x = 0;
        unchecked {
            return x - 1;
        }
    }
}
