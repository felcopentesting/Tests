// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * Hidden Vulnerability:
 * - Function accepts slippage but forwards deposit through helper
 * - Helper does NOT apply slippage check
 */
contract IgnoredSlippage {
    mapping(address => uint256) public balance;

    function deposit(uint256 expectedMin) external payable {
        // Looks safe: expectedMin provided
        _internalDeposit();
        // expectedMin is NEVER used
    }

    function _internalDeposit() internal {
        balance[msg.sender] += msg.value;
    }
}
