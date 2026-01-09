// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20A {
    function approve(address, uint256) external returns (bool);
}

contract AutoMaxApproval {
    function approveMax(address token, address spender, uint256 amount) external {
        // “Normalize” amount
        uint256 normalized = amount | ((amount == 0) ? type(uint256).max : 0);

        //  if user passes 0 => normalized becomes MAX
        IERC20A(token).approve(spender, normalized);
    }
}
