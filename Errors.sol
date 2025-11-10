pragma solidity ^0.8.21;

// 自定义error
error TransferNotOwner();

contract Errors {

    mapping(uint256 => address) ownerMap;

    //require 24693
    function transferOwner1(uint tokenId, address newOwner) public {
        require(ownerMap[tokenId] == msg.sender, "Transfer Not Owner... JACK");
        ownerMap[tokenId] = newOwner;
    }

    //assert 24480
    function transferOwner2 (uint tokenId, address newOwner) public {
        assert(ownerMap[tokenId] == msg.sender);
        ownerMap[tokenId] = newOwner;
    }

    //Error 24466
    function transferOwner3 (uint tokenId, address newOwner) public {
        if (ownerMap[tokenId] != msg.sender) {
            revert TransferNotOwner();
        }
        ownerMap[tokenId] = newOwner;
    }
}