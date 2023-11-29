// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TestToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol)  {
        // 初始化时由合约所有者进行初始铸造
        _mint(msg.sender, 1000000000 * 10**18); // 初始发行 1,000,000,000 个代币
    }

    // Mint 函数，任何人都可以调用进行铸造
    function mint(address to, uint256 amount) public {

        _mint(to, amount);
    }
}