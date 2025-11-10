pragma solidity ^0.8.21;

contract Fallback {
    event ReceiveCallback(address sender, uint value);
    event FallbackCallback(address sender, uint value, bytes data);

    receive() external payable {
        emit ReceiveCallback(msg.sender, msg.value);
    }

    fallback() external payable {
        emit FallbackCallback(msg.sender, msg.value, msg.data);
    }
}