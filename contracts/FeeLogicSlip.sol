// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FeeLogicSlip {
    mapping(address => uint256) public feePaid;

    function payFee(address[] calldata coins, uint256[] calldata amounts) external {
        // looks strict
        require(coins.length == amounts.length, "mismatch");

        uint256 sum;
        for (uint256 i; i < amounts.length; i++) {
            if (amounts[i] == 0) continue;

            // early return prevents full validation
            if (amounts[i] > 1 ether) {
                feePaid[msg.sender] += amounts[i];
                return;
            }

            sum += amounts[i];
        }

        feePaid[msg.sender] += sum;
    }
}
