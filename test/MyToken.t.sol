// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

import {MyToken} from "contracts/MyToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyTokenTest is Test {
    MyToken public myToken = new MyToken("RToken", "RTK");
    address private testAddress = address(1);
    address private testAddress2 = address(2);

    function testShouldTransferFund() public {
        myToken.transfer(msg.sender, 1e18);
        assertEq(myToken.balanceOf(msg.sender), 1e18);
    }

    function testShouldApprove() public {
        myToken.approve(testAddress, 1e20);
        assertEq(myToken.allowance(address(this), testAddress), 1e20);
    }

    function testShouldTransferFrom() public {
        myToken.approve(address(this), 1e19);
        myToken.transferFrom(address(this), testAddress, 1e19);
        assertEq(myToken.balanceOf(testAddress), 1e19);
    }

    function testShouldTransferBetweenTwoAccount() public {
        vm.startPrank(address(this));
        myToken.transfer(testAddress, 1e18);
        vm.stopPrank();

        vm.startPrank(testAddress);
        myToken.transfer(testAddress2, 1e18);
        vm.stopPrank();

        assertEq(myToken.balanceOf(testAddress2), 1e18);
    }

    function testShouldRevert() public {
        vm.expectRevert();
        myToken.transferFrom(testAddress, address(this), 1e18);
    }
}
