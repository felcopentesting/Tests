// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * Hidden vulnerability:
 * - Oracle computes price using balances AFTER transfer from a burn/tax token.
 * - Burn is hidden via safeTransfer wrapper, making the price appear correct.
 */
interface IERC20 {
    function balanceOf(address) external view returns (uint256);
    function transferFrom(address, address, uint256) external returns (bool);
}

contract ShadowBurnOracle {
    IERC20 public tokenA;
    IERC20 public tokenB;

    function update(address pool) external {
        uint256 a = tokenA.balanceOf(pool);
        uint256 b = tokenB.balanceOf(pool);

        // attacker flash-loans + triggers transferFrom(token with burn)
        // reducing supply before oracle reads
        price = (a * 1e18) / b;
    }

    uint256 public price;
}
