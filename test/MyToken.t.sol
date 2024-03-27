// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

import {MyToken} from "contracts/MyToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyTokenTest is Test {
    MyToken public myToken = new MyToken("RToken", "RTK");
    address private testAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address private trestAddress2 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    function testTransferFund() public {
        myToken.transfer(msg.sender, 1e18);
        assertEq(myToken.balanceOf(msg.sender), 1e18);
    }

    function testApprove() public {
        myToken.approve(testAddress, 1e20);
        console.log("%s", myToken.allowance(address(this), testAddress));
        assertEq(myToken.allowance(address(this), testAddress), 1e20);
    }

    function testTransferFrom() public {
        myToken.approve(address(this), 1e19);
        console.log("%s", myToken.allowance(address(this), msg.sender));
        myToken.transferFrom(address(this), trestAddress2, 1e19);
        assertEq(myToken.balanceOf(trestAddress2), 1e19);
    }
}
