pragma solidity ^0.8.21;

contract C {
    address public sender;
    uint256 public num;

    function setVars(uint256 _num) public payable {
        sender = msg.sender;
        num = _num;
    }


}


contract B {
    address public sender;
    uint256 public num;

    function callC(address _addr, uint256 _num) external payable {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }

    function delegateCallC(address _addr, uint256 _num) external payable {
        (bool success, bytes memory data) = _addr.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}