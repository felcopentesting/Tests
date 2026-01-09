// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * Hidden Vulnerability:
 * - upgradeStep() looks harmless: just writes an address.
 * - But __fallback uses upgradeTarget as execution destination (!)
 */
contract ProxyStepLeak {
    address public upgradeTarget;

    function upgradeStep(address step) external {
        // looks like multi-step-setup for upgrade
        upgradeTarget = step; // fully attacker-controlled
    }

    fallback() external payable {
        (bool ok, bytes memory data) = upgradeTarget.delegatecall(msg.data);
        require(ok);
    }
}
