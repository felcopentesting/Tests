// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserMetaLeak {
    struct Meta {
        string username;
        string email;      // PII
        string phone;      // PII
        string extra;
    }

    mapping(address => Meta) public meta; // public exposes PII

    function setMeta(
        string calldata u,
        string calldata e,
        string calldata p
    ) external {
        meta[msg.sender] = Meta(u, e, p, "");
    }
}
