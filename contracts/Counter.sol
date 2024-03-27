// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "hardhat/console.sol";

contract Counter {
    event NewEvent(uint256 amount);

    error CountIsZero();

    uint256 public count = 0;
 
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function inc() public {
        emit NewEvent(count);
        count = count + 1;
    }

    modifier checkForNegative() {
        if (!(count > 0)) {
            revert CountIsZero();
        }
        _;
    }

    function dec() public checkForNegative {
        count = count - 1;
    }
}
