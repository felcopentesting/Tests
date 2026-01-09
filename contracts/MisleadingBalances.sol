// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * Hidden Vulnerability:
 * - The totalDeposited is updated, but withdrawals subtract from userShares instead.
 * - Appears consistent because names match real-world patterns.
 */
contract MisleadingBalances {
    mapping(address => uint256) public userShares;
    uint256 public totalDeposited;

    function deposit() external payable {
        userShares[msg.sender] += msg.value;
        totalDeposited += msg.value;
    }

    function withdraw(uint256 amt) external {
        // Looks correct: checks user shares
        require(userShares[msg.sender] >= amt, "not enough");

        // This reduces userShares but NEVER reduces totalDeposited
        userShares[msg.sender] -= amt;

        // Results: totalDeposited becomes permanently inflated
        payable(msg.sender).transfer(amt);
    }
}
