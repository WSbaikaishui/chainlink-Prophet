// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract AbstractProposition  {
    enum TokenStatus { Pending, Active, Completed, Cancelled }
    enum ProposalType { Normal, Price, Oracle }
    enum ProposalLevel {Safe, Medium, Risky}

    struct PriceProposal {
        address coinPriceFeed;
        int256 aim;
        bool isBig;
    }

    struct OracleProposal {
        string oracleUrl;
        string filter;
        string value;
    }

    struct Proposal {
        uint256 PropositionID;
        string Name;
        string Description;
        address TokenIDYes;
        address TokenIDNo;
        uint256 Deadline;
        TokenStatus Status;
        ProposalLevel Level;
        address JudgeID;
        ProposalType proposalType;
        PriceProposal priceProposal;
        OracleProposal oracleProposal; 
        address Creator;
    }

    // 事件声明
    
    event Deposit(address indexed from, uint256 PropositionID, uint256 amount);
    event AddProposition(address indexed from, uint256 PropositionID, ProposalType proposalType);
    event Deposit(address indexed from, uint256 amount);
    event WRedeem(address indexed user,uint256 PropositionID, uint256 amount);
    event RRedeem(address indexed user,uint256 PropositionID, uint256 amount);
    event ActiveProposition(address indexed user,uint256 PropositionID);
    event JudgePriceProposal(address indexed user,uint256 PropositionID,bool isTrue);
    event JudgeNormalProposal(address indexed user,uint256 PropositionID,bool isTrue);
    event JudgeOracleProposal(address indexed user,uint256 PropositionID,bool isTrue);



    // 函数声明
    function addOracleProposal(string memory _Name, string memory _Description, uint256 _Deadline, string memory _oracleUrl, string memory _filter, string memory _value) public virtual;
    function addPriceProposal(string memory _Name, string memory _Description, uint256 _Deadline, address _priceFeed, int256 _aim, bool _isBig) public virtual;
    function addNormalProposal(string memory _Name, string memory _Description, uint256 _Deadline, string memory _url) public virtual;
    function ActiveProposal(uint256 _ProposalID,ProposalLevel _proposalLevel,bool isAdmin) external virtual;
    function deposit(address to, uint256 _ProposalID, uint256 _Amount) external virtual;
    function Redeem(uint256 _ProposalID, uint256 _Amount) external virtual;
    function WinnerRedeem(uint256 _ProposalID) external virtual;
    function getProposal(uint256 _ProposalID) public view virtual returns ( string memory , 
           string memory , 
            address,
            address,
            uint256, 
            TokenStatus,  
            ProposalLevel);
    // function getProposals() public view virtual returns (Proposal[] memory);
    // function getProposalAdminStatus() public view virtual returns ( bool upkeepNeeded,
    //         bytes memory /*performData*/);
    function judgeNormalProposalByID(uint256 _ProposalID, address _judgeID) external virtual;
    function JudgeOracleProposalByID(uint256 PropositionID) public virtual returns (bytes32);
    function judgePriceProposalByID(uint256 _ProposalID) public virtual;
    function getJudgeID(uint256 _ProposalID) public view virtual returns (address);

    modifier ProposalExists(uint256 _proposalID) virtual;




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
    error ProposalNotOracle(uint256 proposalID);
  
}