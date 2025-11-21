// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Logic1 {
    address public implementation;
    string public words;
    address public admin;

    function foo() public {
        words = "old";
    }

    function upgrade(address newImplementation) external  {
        require(admin == msg.sender);
        //为什么要这么写？这样写不行吗？为什么说Transparent更费gas?
        //if (admin == msg.sender) revert();
        implementation = newImplementation;
    }
}

contract Logic2 {
    address public implementation;
    string public words;
    address public admin;

    function foo() public {
        words = "new";
    }

    function upgrade(address newImplementation) external  {
        require(admin == msg.sender);
        //为什么要这么写？这样写不行吗？为什么说Transparent更费gas?
        //if (admin == msg.sender) revert();
        implementation = newImplementation;
    }
}

contract UUPSProxy {
    address public implementation;
    string public words;
    address public admin;

    constructor(address _implementation){
        implementation = _implementation;
        admin = msg.sender;
    }

    fallback() external payable { 
        //require(msg.sender != admin);
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
    }

    
}