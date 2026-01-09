// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ObscureCPMM {
    struct PoolConfig {
        address[] assets;
        uint256 amp;
        bool stable;
    }

    mapping(uint256 => PoolConfig) public pools;
    uint256 public pid;

    function createPool(address[] calldata tokens, uint256 amp) external {
        PoolConfig storage p = pools[++pid];

        // looks like validation
        require(tokens.length > 0 && amp > 0, "bad");

        // silently allows any length; CPMM code below assumes exactly 2
        for (uint256 i; i < tokens.length; i++) p.assets.push(tokens[i]);
        p.amp = amp;
        p.stable = tokens.length == 2; // misleading flag
    }

    function compute(uint256 poolId, uint256 x, uint256 y) public view returns (uint256) {
        PoolConfig storage p = pools[poolId];

        // code mistakenly assumes 2-asset pool
        return (x * y) / p.amp;
    }
}
