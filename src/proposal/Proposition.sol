// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import  "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";
import "../interfaces/IPropositions.sol";


contract MyToken is ERC20 {
    address admin;
    constructor(string memory name, string memory symbol, address _admin) ERC20(name, symbol) {
        _mint(msg.sender, 0); 
        admin = _admin;
    }
 modifier isAdmin(address _admin) {
        require(admin == _admin, "is not admin");
        _;
    }
     function mint(address to, uint256 amount) public isAdmin(msg.sender) {
        _mint(to, amount);
    }
        function burn(address from, uint256 amount) public isAdmin(msg.sender) {
        _burn(from, amount);
    }
}
// _USDT  = 0xf51D104C16fEC646221789dF97d26B085BE4066B
//  _rewardForJudging = 1000000000000000000
// admin = 0xfbf2C3F116F1705562a0c804C30b4089765E20a2
// _oracle = 0x40193c8518BB267228Fc409a613bDbD8eC5a97b3
//  _jobId = ca98366cc7314957b8c012c72f05aeeb
// _fee = 100000000000000000

contract Proposition is AbstractProposition,ChainlinkClient,AutomationCompatible, Ownable {


     using Strings for uint256;

    IERC20 public USDTContract;
    uint256 public rewardForJudging;

    using Chainlink for Chainlink.Request;
    address private immutable oracle;
    bytes32 private immutable jobId;
    uint256 private immutable fee;


    Proposal[] public proposals;
    uint256[] public proposalAdmin;
    mapping(uint256 => uint256) public proposalDeposits;
    mapping(bytes32 => uint256) public requestForProposal;
    mapping(bytes32 => address) public requestUser;
    constructor(address _USDT, 
        uint256 _rewardForJudging, 
        address admin,  
        address _oracle,
        uint256 _fee,
        address _link) Ownable(admin){
        USDTContract = IERC20(_USDT);
        rewardForJudging = _rewardForJudging;
        oracle = _oracle;
        jobId = "ca98366cc7314957b8c012c72f05aeeb";
        fee = _fee;
        setChainlinkToken(_link);
    }

    //     '0xf51D104C16fEC646221789dF97d26B085BE4066B',
    // '1000000000000000000',
    // '0xfbf2C3F116F1705562a0c804C30b4089765E20a2',
    // '0x40193c8518BB267228Fc409a613bDbD8eC5a97b3',
    // '100000000000000000',
    // '0x326C977E6efc84E512bB9C30f76E30c160eD06FB'

    modifier ProposalExists(uint256 _proposalID) override{
        if(proposals[_proposalID/3].TokenIDYes == address(0)) revert ProposalDoesNotExist(_proposalID);
        _;

    }

    function addOracleProposal(string memory _Name, string memory _Description,uint256 _Deadline, string memory _oracleUrl, string memory _filter, string memory _value) public  override {
        //TODO  设置yes和no token

       MyToken token1  = new MyToken(uint256(proposals.length*3 + 1).toString(),"YES", address(this));
       MyToken token2  = new MyToken(uint256(proposals.length*3 + 2).toString(), "NO", address(this));
        OracleProposal memory normalProp = OracleProposal({
                oracleUrl: _oracleUrl,
                filter: _filter,
                value: _value
            });
        proposals.push( Proposal(
            proposals.length*3,
            _Name, 
            _Description, 
            address(token1),
            address(token2),
            _Deadline, 
            TokenStatus.Pending,  
            ProposalLevel.Risky,
            address(0), 
            ProposalType.Normal,
            PriceProposal(address(0), 0, false),
            normalProp,
            msg.sender
            ));
        bool success = USDTContract.transferFrom(msg.sender, address(this), rewardForJudging);
        if (!success) revert TokenTransferFailed();

        emit AddProposition(msg.sender, proposals.length*3, ProposalType.Oracle);
    }
     

 
    function addPriceProposal(string memory _Name, string memory _Description,uint256 _Deadline, address _priceFeed, int256 _aim, bool _isBig) public  override {
        //TODO  设置yes和no token
         MyToken token1  = new MyToken(uint256(proposals.length*3 + 1).toString(),"YES", address(this));
       MyToken token2  = new MyToken(uint256(proposals.length*3 + 2).toString(), "NO", address(this));
        PriceProposal memory priceProp = PriceProposal({
                coinPriceFeed: _priceFeed,
                aim: _aim,
                isBig: _isBig
            });
         proposals.push(Proposal(
            proposals.length*3,
            _Name, 
            _Description, 
            address(token1),
            address(token2),
            _Deadline, 
            TokenStatus.Pending,  
            ProposalLevel.Risky,
            address(0),
            ProposalType.Price,
            priceProp,
            OracleProposal("", "0", "false"),
     msg.sender
            ));
        bool success = USDTContract.transferFrom(msg.sender, address(this), rewardForJudging);
        if (!success) revert TokenTransferFailed();
        emit AddProposition(msg.sender, proposals.length*3, ProposalType.Price);
    }

    function addNormalProposal(string memory _Name, string memory _Description,uint256 _Deadline, string memory _url) public override  {
     //TODO  设置yes和no token
        MyToken token1  = new MyToken(uint256(proposals.length*3 + 1).toString(),"YES", address(this));
       MyToken token2  = new MyToken(uint256(proposals.length*3 + 2).toString(), "NO", address(this));
  proposals.push(Proposal(
            proposals.length*3,
            _Name, 
            _Description, 
            address(token1),
            address(token2),
            _Deadline, 
            TokenStatus.Pending, 
            ProposalLevel.Risky, 
            address(0),
            ProposalType.Price,
            PriceProposal(address(0), 0, false),
            OracleProposal(_url, "0", "false"),
            msg.sender
            ));
       
     emit AddProposition(msg.sender, proposals.length*3, ProposalType.Normal);
    }


    function ActiveProposal(uint256 _ProposalID, ProposalLevel _proposalLevel, bool isAdmin) external ProposalExists(_ProposalID)  override onlyOwner()  {
        if (proposals[_ProposalID/3].Deadline < block.timestamp) revert ProposalExpired(_ProposalID);
        if(proposals[_ProposalID/3].Status != TokenStatus.Pending) revert ProposalNotPending(_ProposalID);
       
        proposals[_ProposalID/3].Status = TokenStatus.Active;
        proposals[_ProposalID/3].Level = _proposalLevel;
        if (isAdmin){
            proposalAdmin.push(_ProposalID/3);
        }
        emit ActiveProposition(msg.sender, _ProposalID);
    
    }

    function deposit(address to, uint256 _ProposalID, uint256 _Amount) external override ProposalExists(_ProposalID){
        if (_Amount <= 0 ) revert AmountMustBeGreaterThanZero();
        if (proposals[_ProposalID/3].Deadline < block.timestamp) revert ProposalExpired(_ProposalID);
        // 使用 ERC-20 代币合约的 transferFrom 函数将代币从用户地址转移到合约地址
        bool success = USDTContract.transferFrom(msg.sender, address(this), _Amount);
        if (!success) revert TokenTransferFailed();

        MyToken token1 = MyToken(proposals[_ProposalID/3].TokenIDYes);
        MyToken token2 = MyToken(proposals[_ProposalID/3].TokenIDNo);
        token1.mint(to, _Amount);
        token2.mint(to, _Amount);
        proposalDeposits[_ProposalID] += _Amount;
        emit Deposit(msg.sender, _ProposalID, _Amount);
    }

    function Redeem(uint256 _ProposalID, uint256 _Amount) external override ProposalExists(_ProposalID){
         if (_Amount <= 0 ) revert AmountMustBeGreaterThanZero();
        if (proposals[_ProposalID/3].Deadline < block.timestamp) revert ProposalExpired(_ProposalID);
        if (proposals[_ProposalID/3].Status != TokenStatus.Active) revert ProposalNotActive(_ProposalID);
      
     
        MyToken token1 = MyToken(proposals[_ProposalID/3].TokenIDYes);
        MyToken token2 = MyToken(proposals[_ProposalID/3].TokenIDNo);
        if(token1.balanceOf(msg.sender) < _Amount) revert InsufficientBalanceTokenYes( _Amount);
        if(token2.balanceOf(msg.sender) < _Amount) revert InsufficientBalanceTokenNo( _Amount);
       
        token1.burn(msg.sender,_Amount);
        token2.burn(msg.sender, _Amount);
        if (USDTContract.balanceOf(address(this)) < _Amount) revert InsufficientBalanceUSDT(_Amount);
       
        USDTContract.approve(address(this), _Amount);
        bool success = USDTContract.transferFrom(address(this), msg.sender, _Amount);

        if (!success) revert TokenTransferFailed();
        proposalDeposits[_ProposalID] -= _Amount;
        emit RRedeem(msg.sender, _ProposalID, _Amount);
    }


    function WinnerRedeem(uint256 _ProposalID) external override ProposalExists(_ProposalID){
        if (proposals[_ProposalID/3].Status == TokenStatus.Completed) revert ProposalNotJudged(_ProposalID);


        MyToken winnerToken = MyToken(proposals[_ProposalID].JudgeID);
        uint256 balance = winnerToken.balanceOf(msg.sender);
        winnerToken.burn(msg.sender,balance);

        bool success = USDTContract.transferFrom(address(this),msg.sender, balance);
        if (!success) revert TokenTransferFailed();
        proposalDeposits[_ProposalID] -= balance;
        emit WRedeem(msg.sender, _ProposalID, balance);
    }




    function getProposal(uint256 _ProposalID) public override view returns ( 
        string memory , 
           string memory , 
            address,
            address,
            uint256, 
            TokenStatus,  
            ProposalLevel) {
        return (proposals[_ProposalID/3].Name, proposals[_ProposalID/3].Description, proposals[_ProposalID/3].TokenIDYes, proposals[_ProposalID/3].TokenIDNo, proposals[_ProposalID/3].Deadline, proposals[_ProposalID/3].Status,proposals[_ProposalID/3].Level);
    }

    // function getProposals() public view override returns (Proposal[] memory) {
    //     return proposals;
    // }

    // function getProposalsByStatus(TokenStatus _Status) public view override returns (Proposal[] memory) {
    //     Proposal[] memory proposalStatus = new Proposal[](proposals.length);
    //     for (uint256 i = 0; i < proposals.length; i++) {
    //         if (proposals[i].Status == _Status) {
    //               proposalStatus[i] = proposals[i];
    //         }
    //     }
    //     return proposalStatus;
    // }

    function judgeNormalProposalByID(uint256 _ProposalID, address _judgeID)  external override ProposalExists(_ProposalID) {
        if (proposals[_ProposalID/3].Creator != msg.sender) revert  OnlyCreatorCanJudge(_ProposalID);
        if (proposals[_ProposalID/3].Deadline > block.timestamp) revert ProposalNotExpired(_ProposalID);
        if (proposals[_ProposalID/3].TokenIDYes != _judgeID && proposals[_ProposalID/3].TokenIDNo != _judgeID) revert OnlyYesOrNoTokenCanJudge(_judgeID);
        bool isTrue;
        if (proposals[_ProposalID/3].TokenIDYes == _judgeID) {
            isTrue = true;
        }else{
            isTrue = false;
        }
        proposals[_ProposalID/3].JudgeID = _judgeID;
        proposals[_ProposalID/3].Status = TokenStatus.Completed;
        
        emit JudgeNormalProposal(msg.sender,_ProposalID, isTrue);
    }
    

    function JudgeOracleProposalByID(uint256 _ProposalID) public override ProposalExists(_ProposalID) returns (bytes32 requestId){
         if (proposals[_ProposalID/3].Deadline > block.timestamp) revert ProposalNotExpired(_ProposalID);
        if (proposals[_ProposalID/3].proposalType != ProposalType.Oracle) revert ProposalNotOracle(_ProposalID);
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
         request.add(
            "get",
            proposals[_ProposalID/3].oracleProposal.oracleUrl
        );

          request.add("path",  proposals[_ProposalID/3].oracleProposal.filter); // Chainlink nodes 1.0.0 and later support this format

    
        bytes32 req =  sendChainlinkRequest(request, fee);
        requestForProposal[req] = _ProposalID;
        requestUser[req] = msg.sender;
        return req;

    }

    function fulfill(bytes32 _requestId, string memory _oracleResponse) public recordChainlinkFulfillment(_requestId)
    {
        bool isYes ;
        if (compareStrings(_oracleResponse ,proposals[requestForProposal[_requestId]/3].oracleProposal.value)){
            proposals[requestForProposal[_requestId]/3].JudgeID = proposals[requestForProposal[_requestId]/3].TokenIDYes;
            isYes = true;
        }else{
            proposals[requestForProposal[_requestId]/3].JudgeID = proposals[requestForProposal[_requestId]/3].TokenIDNo;
            isYes = false;
        }
        bool success = USDTContract.transferFrom(address(this),requestUser[_requestId], rewardForJudging);
        if (!success) revert TokenTransferFailed();
        emit JudgeOracleProposal(requestUser[_requestId],requestForProposal[_requestId],isYes);

    }


    function judgePriceProposalByID(uint256 _ProposalID)  public override ProposalExists(_ProposalID) {
         if (proposals[_ProposalID/3].Deadline > block.timestamp) revert ProposalNotExpired(_ProposalID);
    
        (, int256 price,,,) = AggregatorV3Interface(proposals[_ProposalID/3].priceProposal.coinPriceFeed).latestRoundData();
        bool isTrue;
        if (proposals[_ProposalID/3].priceProposal.isBig) {
            if (price >= proposals[_ProposalID/3].priceProposal.aim) {
                proposals[_ProposalID/3].JudgeID = proposals[_ProposalID/3].TokenIDYes;
                 isTrue = true;
               
            }else{
                proposals[_ProposalID/3].JudgeID = proposals[_ProposalID/3].TokenIDNo;
                 isTrue = false;
            }
        }else{
             if (price <= proposals[_ProposalID/3].priceProposal.aim) {
                proposals[_ProposalID/3].JudgeID = proposals[_ProposalID/3].TokenIDYes;
                isTrue = true;
            }else{
                proposals[_ProposalID/3].JudgeID = proposals[_ProposalID/3].TokenIDNo;
                isTrue = false;
            }
        }
       
        proposals[_ProposalID/3].Status = TokenStatus.Completed;
        // bool success = ;
        if (!USDTContract.transferFrom(address(this),msg.sender , rewardForJudging)) revert TokenTransferFailed();
        emit JudgePriceProposal(msg.sender, _ProposalID, isTrue);
    }
    function getJudgeID(uint256 _ProposalID) public view override returns (address) {
        return proposals[_ProposalID/3].JudgeID;
    }

   function checkUpkeep(
        bytes memory  checkData/* checkData*/ 
    ) 
        public 
        view 
        override
        returns (
            bool upkeepNeeded,
            bytes memory /*performData*/
        )
    {
        
        upkeepNeeded = false;
           uint256 count = 0;
             uint256 indexCount = 0;
        for (uint256 i = 0; i < proposalAdmin.length && !upkeepNeeded; i++){
            if (block.timestamp > proposals[proposalAdmin[i]].Deadline ){
                upkeepNeeded = true;
                count++;
                
            }
        }
         uint256[] memory indexToUpdate = new uint256[](count);
        for(uint256 i = 0; i <  proposalAdmin.length; i++) {
            if(block.timestamp > proposals[proposalAdmin[i]].Deadline) {
                indexToUpdate[indexCount] = i;
                indexCount++;
            }
        }

        checkData = abi.encode(indexToUpdate);
        return (upkeepNeeded, checkData);

    }


    function performUpkeep(
        bytes memory performData
    ) 
        external 
        override 
    {
        //在此添加 solidity 代码
        uint256[] memory indexToUpdate = abi.decode(performData, (uint256[]));
        for(uint256 i = 0; i < indexToUpdate.length; i++) {
            if (proposals[indexToUpdate[i]].proposalType ==ProposalType.Price){
                judgePriceProposalByID(indexToUpdate[i]);
            }else if (proposals[indexToUpdate[i]].proposalType ==ProposalType.Oracle){
                JudgeOracleProposalByID(indexToUpdate[i]);
            }
        }
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
    return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
}
}

 
