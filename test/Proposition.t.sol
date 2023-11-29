// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";

import {Proposition} from "../src/Proposition.sol";

import {TestToken} from "../src/erc20.sol";

contract TestProposition is Test {
    TestToken public tToken;
    Proposition public proposition;
    address public alice;

    function setUp() public {
        tToken = new TestToken("test", "tt");
        alice = address(0x1234567890123456789012345);
        tToken.mint(alice, 1000000000000000000000);
        proposition = new Proposition(address(tToken), 100000000000000000000000000);
        vm.startPrank(alice);
        proposition.addNormalProposal("test","test",1703695333000,"rettasda");
        vm.stopPrank(alice);

    }

    function test_deposit() public {
         vm.startPrank(alice);
        proposition.deposit(0,100000000);
        vm.stopPrank(alice);
    }

}