// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * Hidden Vulnerability:
 * - Contract appears initialized due to unrelated flag `bootCompleted`.
 * - Real init storage (owner assignment) can be hijacked ANY time.
 */
contract InitShadowBug {
    address public owner;
    bool public bootCompleted; // looks like initialization flag

    function initialize() external {
        // Appears safe since it "checks" bootCompleted
        require(!bootCompleted, "booted");

        // bootCompleted is never set in this function
        // meaning initialize() can be called repeatedly.
        owner = msg.sender;
    }

    function finalizeBoot() external {
        // This is misleading: only toggles unrelated flag
        bootCompleted = true;
    }
}
