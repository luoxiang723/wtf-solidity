pragma solidity ^0.8.21;

import {ERC20} from "../31_ERC20/ERC20.sol";

contract Airdrop {

    mapping(address => uint) failTransferList;//失败映射

    // _addresses填写
    //["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"]

    // _amounts填写
    //[100, 200]
    function multiTransferToken (address _token, address[] calldata _addresses, uint[] calldata _amounts) external {
        require (_addresses.length == _amounts.length, "Lengths of Addresses and Amounts NOT EQUAL");
        ERC20 token = ERC20(_token);
        //计算空投ERC20代币单位数量
        uint _amountsSum = getSum(_amounts);
        //检查授权代币数量 >= 空投总量
        require (token.allowance(msg.sender, address(this)) >= _amountsSum, "Need Approve ERC20 token");
        //为什么不做balance检查？//会报 Note: The called function should be payable if you send value and the value you send should be less than your current balance.
        for(uint i=0; i<_addresses.length; i++) {
            token.transferFrom(msg.sender ,_addresses[i], _amounts[i]);
        }
    }

    function multiTransferETH (address _token, address payable[] calldata _addresses, uint[] calldata _amounts) payable  external {
        require (_addresses.length == _amounts.length, "Lengths of Addresses and Amounts NOT EQUAL");
        //计算空投ETH单位数量
        uint _amountsSum = getSum(_amounts);
        //为什么要 == ？>= 不行吗？有什么特别的说法？
        require (msg.value == _amountsSum, "Transfer amount error");
        for(uint i=0; i<_addresses.length; i++) {
            //_addresses[i].transfer(_amounts);
            (bool success, bytes memory data) = _addresses[i].call{value:_amounts[i]}("");
            //为什么会失败？失败的原因有哪些？
            if(!success) {
                failTransferList[_addresses[i]] = _amounts[i];
            }
        }
    }

    //给空投失败提供主动操作机会
    function withdrawFromFailList(address payable  _to) external {
        uint failAmount = failTransferList[msg.sender];
        require (failAmount > 0, "You are not in failed list");
        failTransferList[msg.sender] = 0;
        (bool success, bytes memory data) = _to.call{value:failAmount}("");
        //为什么用require？用assert行不行？
        require (success);
    }

    function getSum(uint[] calldata _amounts) private pure returns(uint) {
        uint sum = 0;
        for(uint i=0; i<_amounts.length; i++){
            sum += _amounts[i];
        }
        return sum;
    }
}