// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PackedRecord {
    mapping(bytes32 => uint256) public records;

    struct Rec {
        uint128 a;
        uint64 b;
        string tag; // dynamic
    }

    function store(Rec calldata r, uint256 val) external {
        // This looks like a strict packed record key
        bytes32 key = keccak256(abi.encodePacked(r.a, r.b, r.tag));

        // dynamic type + encodePacked allows collisions
        records[key] = val;
    }
}
