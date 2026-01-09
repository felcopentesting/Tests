// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WeirdEvalOrder {
    uint256 public n;

    function compute(uint256 x) external returns (uint256) {
        //  n++ used as part of expression leads to different output depending on compiler version
        return x * (n++) + (x - n);
    }
}
