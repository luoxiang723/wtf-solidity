pragma solidity ^0.8.21;

import {ERC20} from "../31_ERC20/ERC20.sol";

contract Faucet {
    uint256 public amountAllowed = 100;//每次领100单为代币
    address public tokenContract;//token合约地址（发放代币合约的地址）
    mapping(address => bool) public requestedAddress;//记录已经领取过代币的地址

    event SendToken(address receiver, uint256 amount);

    constructor (address _addr) {
        tokenContract = _addr;
    }

    function requestToken() external {
        require(!requestedAddress[msg.sender], "Address Already Requested");
        //校验是否领取过
        //为什么不是写 ERC20 token = ERC20(tokenContract);？
        ERC20 token = ERC20(tokenContract);
        //校验越是否充足
        //require(token.balanceOf() >= amountAllowed, "Faucet Empry"); //为什么不是这么写的？
        require(token.balanceOf(address(this)) >= amountAllowed, "Faucet Empry");
        token.transfer(msg.sender, amountAllowed);
        requestedAddress[msg.sender] = true;
        emit SendToken(msg.sender, amountAllowed);

    }


}