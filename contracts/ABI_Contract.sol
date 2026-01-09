// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TieredAccessVault {
    struct TierConfig {
        address[] premium;
        address[] standard;
        uint64 expiresAt;
        uint8 tierId;
    }

    mapping(bytes32 => bool) private approvedGroups;
    mapping(bytes32 => uint256) private withdrawAmounts;

    // Admin-only
    address public owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // --- Admin: configure group & amount ---
    function configureTierGroup(TierConfig calldata cfg, uint256 amount) external onlyOwner {
        // Construct a key for this configuration
        // ⚠️ Hidden risk: premium + standard arrays + expiresAt are packed together
        bytes32 key = keccak256(
            abi.encodePacked(
                cfg.premium, 
                cfg.standard,
                cfg.expiresAt
                // tierId appended as a static type, but also packed ambiguously
                , cfg.tierId
            )
        );

        approvedGroups[key] = true;
        withdrawAmounts[key] = amount;
    }

    // --- Claims ---
    function claim(TierConfig calldata userCfg) external {
        bytes32 userKey = keccak256(
            abi.encodePacked(
                userCfg.premium, 
                userCfg.standard,
                userCfg.expiresAt,
                userCfg.tierId
            )
        );

        require(block.timestamp < userCfg.expiresAt, "Expired");
        require(approvedGroups[userKey], "Group not authorized");

        uint256 amount = withdrawAmounts[userKey];
        require(amount > 0, "Nothing to claim");

        // One-time withdraw
        withdrawAmounts[userKey] = 0;

        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "Transfer failed");
    }

    // fund vault
    receive() external payable {}
}
