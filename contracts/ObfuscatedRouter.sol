// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * ObfuscatedRouter – intentionally complex router simulation
 * Contains subtle gas-DoS vulnerability through unbounded nested loops
 * disguised behind "batch execution" and "route aggregation".
 */
contract ObfuscatedRouter {
    struct Step {
        address target;
        uint256 amount;
        bytes data;
    }

    struct Route {
        Step[] steps;
        uint8 mode;
        uint256 fee;
    }

    struct Batch {
        Route[] routes;
        address beneficiary;
    }

    mapping(address => uint256) internal _balances;

    event Executed(address indexed user, uint256 routes, uint256 steps);
    event StepDone(address indexed target, uint256 amount);

    // --- PUBLIC ENTRYPOINT ---
    function execute(Batch calldata batch) external payable {
        // Fake validation logic (incomplete)
        require(batch.beneficiary != address(0), "bad bnf");

        // ❌ VULNERABILITY ROOT CAUSE:
        // No limit on batch.routes length
        for (uint256 i; i < batch.routes.length; ++i) {
            _processRoute(batch.routes[i]);
        }

        emit Executed(msg.sender, batch.routes.length, 0);
    }

    // --- INTERNAL PROCESSOR ---
    function _processRoute(Route calldata route) internal {
        // Fake “gas optimization” (misleading)
        unchecked {
            if (route.mode == 1 && route.fee > 0) {
                _balances[msg.sender] += route.fee; 
            }
        }

        // ❌ VULNERABILITY ROOT CAUSE:
        // steps array fully controlled by user, no bounds
        for (uint256 j; j < route.steps.length; ++j) {
            _runStep(route.steps[j]);
        }
    }

    // --- CORE STEP EXECUTION ---
    function _runStep(Step calldata s) internal {
        // Even more subtle: internal loop hidden inside
        bytes memory payload = s.data;

        // ❌ Hidden nested loop:
        // User can send calldata with arbitrary length,
        // and this loop iterates through all bytes again.
        // Combined with previous loops = N * M * K worst case gas bomb.
        for (uint256 k; k < payload.length; ++k) {
            // Fake computation
            if (k % 11 == 0) {
                // simulate state change
                _balances[s.target] ^= uint256(uint160(s.target));
            }
        }

        emit StepDone(s.target, s.amount);
    }

    // --- VIEW HELPERS ---
    function balanceOf(address a) external view returns (uint256) {
        return _balances[a];
    }
}
