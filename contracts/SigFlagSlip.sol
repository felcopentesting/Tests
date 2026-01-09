// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * Hidden Vulnerability:
 * - Two independent flags appear to strengthen security.
 * - But validation passes if EITHER flag passes.
 * - Attacker sets inactiveFlag=true to bypass signature.
 */
contract SigFlagSlip {
    mapping(address => bool) public activeFlag;
    mapping(address => bool) public inactiveFlag;

    function validate(bytes32 hash, bytes calldata sig) internal view returns (bool) {
        bool sigValid = (recover(hash, sig) == msg.sender);

        // Bypass: if inactiveFlag is true, signature is ignored
        return sigValid || inactiveFlag[msg.sender];
    }

    function recover(bytes32, bytes calldata) internal pure returns (address) {
        // not implemented: always returns zero
        return address(0);
    }

    function execute(bytes32 hash, bytes calldata sig) external {
        require(validate(hash, sig), "invalid");
    }
}
