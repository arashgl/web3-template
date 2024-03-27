// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Dex {
    address public token1;
    address public token2;

    constructor(address _token, address _token2) {
        token1 = _token;
        token2 = _token2;
    }

    function addLiquidity(address tokenAddress, uint256 amount) public {
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
    }

    function swap(address from, address to, uint256 amount) public {
        require(
            (from == token1 && to == token2) ||
                (from == token2 && to == token1),
            "Invalid token pair!"
        );
        require(
            IERC20(from).balanceOf(msg.sender) >= amount,
            "Not enough balance to swap!"
        );
        uint256 swapAmount = getSwapRate(from, to, amount);

        IERC20(from).transferFrom(msg.sender, address(this), amount);

        IERC20(to).transfer(msg.sender, swapAmount);
    }

    function getSwapRate(
        address from,
        address to,
        uint256 amount
    ) public view returns (uint256) {
        return
            amount *
            (IERC20(to).balanceOf(address(this)) /
                IERC20(from).balanceOf(address(this)));
    }

    function balanceOf(
        address token,
        address account
    ) public view returns (uint256) {
        return IERC20(token).balanceOf(account);
    }

    function dexAddress() public view returns (address) {
        return address(this);
    }
}
