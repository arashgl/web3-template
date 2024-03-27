// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenA is ERC20 {
    uint256 public INITIAL_SUPPLY;
    address public owner;

    constructor() ERC20("TokenA", "TKA") {
        owner = msg.sender;
        INITIAL_SUPPLY = 600 * (10 ** uint8(decimals()));
        _mint(owner, INITIAL_SUPPLY);
        emit Transfer(address(0), owner, INITIAL_SUPPLY);
    }
}
