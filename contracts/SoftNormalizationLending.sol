// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * Hidden Vulnerability:
 * - normalize() divides by scale factor that attacker controls indirectly.
 * - Allows inflating collateral value & borrowing excess.
 */
contract SoftNormalizationLending {
    uint256 public scale = 1e18;
    mapping(address => uint256) public collateral;

    function updateScale(uint256 s) external {
        // innocently named
        require(s > 0, "bad");
        scale = s;
    }

    function normalize(uint256 price) internal view returns (uint256) {
        // attacker sets scale to tiny value => inflated normalized price
        return price * 1e18 / scale;
    }

    function borrow(uint256 price) external {
        uint256 norm = normalize(price);
        collateral[msg.sender] += norm;
    }
}
