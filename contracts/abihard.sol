// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TieredIncentiveManager
 * @dev This contract manages incentive tiers, reward groups, and off-chain approved bundles.
 *
 * The vulnerability is subtle and hidden in how group membership
 * is hashed using abi.encodePacked inside an internal helper.
 */

library ArrayUtils {
    // Looks innocent: returns a "deterministic key" for a group
    function groupKey(address[] memory a, address[] memory b)
        internal pure returns (bytes32)
    {
        // ⚠️ Hidden vulnerability:
        // abi.encodePacked(a, b) packs dynamic arrays without length delimiters
        // allowing collisions.
        return keccak256(abi.encodePacked(a, b));
    }
}

contract TieredIncentiveManager {
    using ArrayUtils for address[];

    struct TierInfo {
        uint32 boost;
        uint32 cooldown;
        bool active;
    }

    mapping(uint256 => TierInfo) public tierData;

    // Looks like an allowlist for reward bundles
    mapping(bytes32 => bool) private approvedBundles;

    event BundleRegistered(bytes32 bundleKey);
    event IncentiveClaimed(address indexed user, uint256 reward);

    constructor() {
        // Populate a few fake tiers
        tierData[1] = TierInfo(110, 24 hours, true);
        tierData[2] = TierInfo(130, 12 hours, true);
        tierData[3] = TierInfo(150,  6 hours, true);
    }

    // Admin function to whitelist a reward bundle
    function registerBundle(address[] calldata vip, address[] calldata standard)
        external
    {
        bytes32 key = ArrayUtils.groupKey(_cop(vip), _cop(standard));
        approvedBundles[key] = true;
        emit BundleRegistered(key);
    }

    // Main function to claim incentive distribution
    function claimIncentives(
        uint256 tier,
        address[] calldata vip,
        address[] calldata standard
    ) external {
        require(tierData[tier].active, "Tier inactive");

        bytes32 key = ArrayUtils.groupKey(_cop(vip), _cop(standard));
        require(approvedBundles[key], "Unauthorized bundle");

        // Consume authorization
        approvedBundles[key] = false;

        uint256 baseReward = 0.01 ether * tierData[tier].boost / 100;

        // Payout logic
        for (uint i = 0; i < vip.length; i++) {
            _payout(vip[i], baseReward * 2); // VIP reward double
        }
        for (uint i = 0; i < standard.length; i++) {
            _payout(standard[i], baseReward);
        }
    }

    // Hidden utility to avoid calldata → memory differences (red herring)
    function _cop(address[] calldata x) internal pure returns (address[] memory m) {
        m = new address[](x.length);
        for (uint i; i < x.length; i++) m[i] = x[i];
    }

    function _payout(address user, uint256 amount) internal {
        if (amount == 0) return;
        (bool ok, ) = user.call{value: amount}("");
        require(ok, "Transfer failed");
        emit IncentiveClaimed(user, amount);
    }

    // Deposit ETH
    receive() external payable {}
}
