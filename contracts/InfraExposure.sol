// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InfraExposure {
    struct NodeInfo {
        string service;
        string endpoint; // exposes IP/URL
    }

    NodeInfo public current; // publicly exposed

    function updateNode(string calldata svc, string calldata url) external {
        current = NodeInfo(svc, url);
    }
}
