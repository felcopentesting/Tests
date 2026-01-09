// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20B {
    function approve(address, uint256) external returns (bool);
}

contract AllowanceRace {
    mapping(address => uint256) public desired;

    function changeAllowanceSafely(address token, uint256 newAmount) external {
        // writes desired allowance AFTER approval
        // creating frontrunning window
        IERC20B(token).approve(msg.sender, newAmount);

        // attacker frontruns, pulls old + new
        desired[msg.sender] = newAmount;
    }
}
