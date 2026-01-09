// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * Hidden Vulnerability:
 * - execAdmin takes bytes[] then ABI-encodes it again
 * - making it appear "structured"
 * - But the underlying call is still user-controlled delegatecall
 */
contract EncodedAdminExec {
    address public controller;

    function execAdmin(bytes[] calldata adminData) external {
        require(msg.sender == controller, "not ctl");

        // double-encoding gives false sense of safety
        bytes memory payload = abi.encode(adminData);

        (bool ok, ) = address(this).delegatecall(payload);
        require(ok);
    }
}
