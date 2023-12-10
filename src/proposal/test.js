const Web3 = require('web3');
const web3 = new Web3();

const abiEncodedParams = web3.eth.abi.encodeParameters(
  ['address', 'uint256', 'address', 'address', 'uint256', 'address'],
  [
    '0xf51D104C16fEC646221789dF97d26B085BE4066B',
    '1000000000000000000',
    '0xfbf2C3F116F1705562a0c804C30b4089765E20a2',
    '0x40193c8518BB267228Fc409a613bDbD8eC5a97b3',
    '100000000000000000',
    '0x326C977E6efc84E512bB9C30f76E30c160eD06FB'
  ]
);

console.log(abiEncodedParams);