// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";



contract AnyApiTask is ChainlinkClient {
 using Chainlink for Chainlink.Request;

    uint256 public volume;
    address private immutable oracle;
    bytes32 private immutable jobId;
    uint256 private immutable fee;

    event DataFulfilled(uint256 volume);
    mapping(bytes32 => address) public pendingRequests;

    constructor(
        address _oracle,
        bytes32 _jobId,
        uint256 _fee,
        address _link
    ) {
        if (_link == address(0)) {
            setPublicChainlinkToken();
        } else {
            setChainlinkToken(_link);
        }
        oracle = _oracle;
        jobId = _jobId;
        fee = _fee;
    }

    /*
     * 步骤 1 - 构建一个 Chainlink request
     * 通过 requestVolume 函数，给 Chainlink 发送获取外部数据请求
     */    
    function requestVolume() public returns (bytes32 requestId) {
    
        Chainlink.Request memory request = buildChainlinkRequest(JobID, address(this), 
        this.singleResponseFulfill.selector);

        // Set the URL to perform the GET request on
        request.add("proxyAddress", addressToString(_proxyAddress));
        request.add("unixDateTime", uint2str(_unixTime));

        //set the timestamp being searched, we will use it for verification after
        uitn256 requestId = sendChainlinkRequestTo(oracle, request, fee);
        pendingRequests[requestId] = address(0);
        // Sends the request 
        return requestId;
    }

    /*
     * 步骤 2 - 接受 Chainlink 返回的数据
     * 通过 fulfill 函数，从外部 API 获得一个数据
     */    
    function fulfill(bytes32 _requestId, uint256 _volume) public recordChainlinkFulfillment(_requestId) {
        /**
         * 在这里添加代码，在本地网络中可以使用任意一个 API
         * 奖 _volume 存储在 volume 中
         * 可以参考此处代码：https://docs.chain.link/any-api/get-request/examples/single-word-response
         * **/
        emit DataFulfilled(volume);
    }

    function withdrawLink() external {}

}

