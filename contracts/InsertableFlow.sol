// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InsertableFlow {
    uint256 public marked;
    uint256 public staked;

    function mark(uint256 x) external {
        marked = x;
    }

    function commit() external {
        // commit uses marked which can be manipulated via insertion MEV
        staked += marked;
    }
}
