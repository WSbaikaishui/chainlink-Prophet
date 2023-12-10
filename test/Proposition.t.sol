// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";

import {Proposition} from "../src/proposal/Proposition.sol";

import {TestToken} from "../src/erc20.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestProposition is Test {
    TestToken public tToken;
    Proposition public proposition;
    address public alice;

    function setUp() public {
        tToken = new TestToken("test", "tt");
        alice = address(0x1234567890123456789012345);
        tToken.mint(alice, 1000000000000000000000);
    
        // proposition = new Proposition(address(tToken), 121212, address(alice));
        vm.startPrank(alice);
        // proposition.addNormalProposal("test","test",1703695333000,"rettasda");
        // proposition.ActiveProposal(0);
        vm.stopPrank();

    }

    function test_depositWithRange(uint256 x) public {
        uint256 boundedValue = x % 10000000000; // 限制 x 在 0 到 99 之间
        console2.log("Testing deposit function");
        vm.startPrank(alice);
    //     tToken.approve(address(proposition), boundedValue);
    //     Proposition.Proposal memory proposal = proposition.getProposal(0);
      
    //     ERC20 TokenYes = ERC20(proposal.TokenIDYes);
    //     ERC20 TokenNo = ERC20(proposal.TokenIDNo);
    //     console2.log("tToken:",tToken.balanceOf(address(proposition)));
    //     console2.log("TokenYes:",TokenYes.balanceOf(address(alice)));
    //     console2.log("TokenNo:",TokenNo.balanceOf(address(alice)));
    //     if (boundedValue == 0){
    //         try proposition.deposit(alice, 0, boundedValue) {
    //                  fail("Expected deposit to fail, but it succeeded");
    //     } catch {
    // // Expected failure, test passes
    // console2.log("Expected deposit to fail, it failed");
    //     }
    //     }else{
    //          proposition.deposit(alice,0,boundedValue);
    //     }
      
    //      console2.log("TokenYesAfterDeposit:",TokenYes.balanceOf(address(alice)));
    //     console2.log("TokenNoAfterDeposit:",TokenNo.balanceOf(address(alice)));
    //     console2.log("tTokenAfterDeposit:",tToken.balanceOf(address(proposition)));
        vm.stopPrank();
    }

    function test_redeem(uint256 x) public {
        uint256 boundedValue = x % 10000000000; // 限制 x 在 0 到 99 之间
        vm.startPrank(alice);
    //     tToken.approve(address(proposition), boundedValue);
    //             if (boundedValue == 0){
    //         try proposition.deposit(alice, 0, boundedValue) {
    //                  fail("Expected deposit to fail, but it succeeded");
    //     } catch {
    // // Expected failure, test passes
    // console2.log("Expected deposit to fail, it failed");
    //     }
    //     }else{
    //          proposition.deposit(alice,0,boundedValue);
    //     }
        // Proposition.Proposal memory proposal = proposition.getProposal(0);
      
        // ERC20 TokenYes = ERC20(proposal.TokenIDYes);
        // ERC20 TokenNo = ERC20(proposal.TokenIDNo);
        // console2.log("tToken:",tToken.balanceOf(address(proposition)));
        // console2.log("TokenYes:",TokenYes.balanceOf(address(alice)));
        // console2.log("TokenNo:",TokenNo.balanceOf(address(alice)));
        // if (boundedValue == 0){
        // try   proposition.Redeem(0,boundedValue) {
        //              fail("Expected deposit to fail, but it succeeded");
        // } catch {
        //         // Expected failure, test passes
        //         console2.log("Expected deposit to fail, it failed");
        // }
        // }else{
        //        proposition.Redeem(0,boundedValue);
        // }
      
        
        
        // console2.log("TokenYesAfterRedeem:",TokenYes.balanceOf(address(alice)));
        // console2.log("TokenNoAfterRedeem:",TokenNo.balanceOf(address(alice)));
        // console2.log("tTokenAfterRedeem:",tToken.balanceOf(address(proposition)));
        vm.stopPrank();
    }
}