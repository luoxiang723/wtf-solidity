pragma solidity ^0.8.21;

import {IERC20} from "./IERC20.sol";

contract ERC20 is IERC20 {
    mapping(address => uint256 ) public override balanceOf;

    //mapping(ownerAddress => mapping(spenderAddress => amount))
    mapping(address => mapping(address => uint256 )) public override allowance;
    uint256 public override totalSupply;//代币总供给

    string public name;//名称
    string public symbol;//符号
    uint8 public decimals=18;//小数位数

    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
    }

    // function totalSupply() external view override returns (uint256){
    //     return totalSupply;
    // }

    // function balanceOf(address addr) external view override returns(uint256) {
    //     return balanceOf[addr];
    // }

    function transfer(address to, uint256 amount) external override returns(bool){
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // function allowance(address owner, address spender) external view override returns (uint256){
    //     return allowance[owner][spender];
    // }

    //msg.sender是owner, spender是spender
    function approve(address spender, uint256 amount) external override returns(bool) {
        allowance[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    //from 是owner, msg.sender是spender,
    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        //allowance[msg.sender][from] -= amount;//为什么不是这么写的呢？
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    //铸币交易
    function mint(uint256 amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    //销毁代币
    function burn(uint256 amount) external  {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

}