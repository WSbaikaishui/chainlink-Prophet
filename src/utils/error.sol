// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ErrorDefinitions {
    // 自定义错误
    error IsNotAdmin(address caller);
    error ProposalDoesNotExist(uint256 proposalID);
    error ProposalExpired(uint256 proposalID);
    error ProposalNotExpired(uint256 proposalID);
    error ProposalNotPending(uint256 proposalID);
    error ProposalNotActive(uint256 proposalID);
    error AmountMustBeGreaterThanZero();
    error TokenTransferFailed();
    error InsufficientBalanceTokenYes(uint256 requiredAmount);
    error InsufficientBalanceTokenNo(uint256 requiredAmount);
    error InsufficientBalanceUSDT(uint256 requiredAmount);
    error ProposalNotJudged(uint256 proposalID);
    error OnlyCreatorCanJudge(uint256 proposalID);
    error OnlyYesOrNoTokenCanJudge(address judgeID);
}