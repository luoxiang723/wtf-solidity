// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BeggingContract is Ownable {

    event Donate(address from, uint256 amount);
    event Withdraw(address owner, uint256 amount);

    //总余额
    uint256 public _donateSum;
    uint256 public _releaseSum;

    //捐赠开始时间
    uint256 public _donateStartTime;
    //捐赠时长
    uint256 public _donateDurationTime;

    //捐赠top3地址 捐赠排行榜：实现一个功能，显示捐赠金额最多的前 3 个地址。
    address[3] public _donaterTop3;

    //一个 mapping 来记录每个捐赠者的捐赠金额。
    mapping(address => uint256 amt) private _donates;

    constructor(uint256 startTime, uint256 duration) Ownable(msg.sender) {
        _donateStartTime = startTime;
        _donateDurationTime = duration;
    }

    /**
     * 提现   一个 withdraw 函数，允许合约所有者提取所有资金。
     * 使用 payable 修饰符和 address.transfer 实现支付和提款。
     * 使用 onlyOwner 修饰符限制 withdraw 函数只能由合约所有者调用。
     */
    function withdraw(uint256 amt) external payable onlyOwner {
        require (_donateSum >= _releaseSum + amt, "amt not available");
        _releaseSum += amt;
        (bool success,) = owner().call{value: amt}("");
        if(!success){
            revert("withdraw failed");
        }
        emit Withdraw(owner(), amt);
    }

    receive() external payable {
        donate();
    }

    fallback() external payable {
        donate();
    }

    /**
     *  一个 donate 函数，允许用户向合约发送以太币，并记录捐赠信息。
     * 使用 payable 修饰符和 address.transfer 实现支付和提款。
     */
    function donate() public payable {
        require(msg.value > 0, "value should be greater than zero");
        require(block.timestamp > _donateStartTime, "donate not start");
        require(block.timestamp < _donateStartTime + _donateDurationTime, "donate has been ended");

        _donates[msg.sender] += msg.value;
        _donateSum += msg.value;

        uint256 sumAmt = _donates[msg.sender];

        //计算top3
        for(uint8 i = 0; i<3; i++){
            address donater = _donaterTop3[i];
            if(sumAmt > _donates[donater]){
                for (uint j = 2-i; j>0; j--) {
                    if(j > 0){
                        _donaterTop3[j] = _donaterTop3[j-1];
                    }
                    //i=0,
                    //    j=2, _donaterTop3[2] =  _donaterTop3[1]
                    //    j=1, _donaterTop3[1] =  _donaterTop3[0]
                    //i=1,
                    //    j=1, _donaterTop3[1] =  _donaterTop3[0]
                    //i=2,
                    //    j=0, 不执行
                }
                _donaterTop3[i] = msg.sender;
                break;
            }
        }
        emit Donate(msg.sender, msg.value);
    }

    /**
     * 一个 getDonation 函数，允许查询某个地址的捐赠金额。
     */
    function getDonate(address donater) external view returns(uint256) {
        return _donates[donater];
    }

    /**
     * 获取排行榜
     */
    function getTop3() external view returns (address[3] memory) {
        return _donaterTop3;
    }

}