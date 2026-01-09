// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * Hidden Vulnerability:
 * - OnlyAdmin modifier is hidden behind an emergency-switch condition.
 * - Root override still possible during "non-emergency" state.
 */
contract RootOverride {
    bytes32 public currentRoot;
    address public admin;
    bool public emergencyMode;

    modifier onlyAdmin() {
        // Looks correct but has subtle bypass
        if (emergencyMode) {
            require(msg.sender == admin, "no admin");
        }
        _; // In non-emergency mode ANYONE can call
    }

    function updateRoot(bytes32 newRoot) external onlyAdmin {
        currentRoot = newRoot;
    }
}
