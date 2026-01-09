// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ConfigSwap {
    struct SwapConfig {
        uint256 mode;
        uint256 priority;
    }

    SwapConfig public cfg;

    function configure(uint256 m, uint256 p) external {
        cfg = SwapConfig(m, p);
    }

    function swap(uint256 amountIn) external payable {
        // config pretends to enforce something
        require(cfg.mode <= 2, "bad");

        // no deadline, no minOut
        // fully MEV-exploitable
        payable(msg.sender).transfer(amountIn);
    }
}
