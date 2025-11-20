// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Logic1 {
    address public implementation;
    string public words;
    address public admin;

    function foo() public {
        words = "old";
    }
}

contract Logic2 {
    address public implementation;
    string public words;
    address public admin;

    function foo() public {
        words = "new";
    }
}

contract SimpleUpgrade {
    address public implementation;
    string public words;
    address public admin;

    constructor(address _implementation){
        implementation = _implementation;
        admin = msg.sender;
    }

    fallback() external payable { 
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
    }

    function upgrade(address newImplementation) external  {
        require(admin == msg.sender);
        implementation = newImplementation;
    }
}