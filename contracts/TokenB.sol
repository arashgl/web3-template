// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TokenB is ERC20 {
    uint256 public initialSupply;
    address public owner;

    constructor() ERC20("TokenB", "TKB") {
        owner = msg.sender;
        initialSupply = 600 * (10 ** uint8(decimals()));
        _mint(owner, initialSupply);
        emit Transfer(address(0), owner, initialSupply);
    }
}
