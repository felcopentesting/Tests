// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * Hidden Vulnerability:
 * - Multicall uses a "session hash" that only covers the FIRST call.
 * - If a later sub-call reverts, the first one still succeeds -> partial replay.
 * - The bug is disguised behind benign "session bookkeeping".
 */
contract StealthReplay {
    mapping(address => bytes32) public lastSession;

    function multicall(bytes[] calldata calls, bytes32 sessionTag) external {
        // Looks like we bind sessionTag to entire payload…
        bytes32 session = keccak256(abi.encodePacked(msg.sender, sessionTag));
        
        // But we only store it BEFORE calls execute.
        lastSession[msg.sender] = session;

        for (uint256 i = 0; i < calls.length; i++) {
            // Looks atomic but isn't.
            (bool ok, ) = address(this).call(calls[i]);

            // If one fails, execution STOPS but earlier calls remain committed.
            if (!ok) break;
        }
    }

    // sub-call example
    uint256 public counter;
    function increment() external { counter++; }
}
