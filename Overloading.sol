pragma solidity ^0.8.00;

contract OverLoading {

    function saySomething() public pure returns (string memory) {
        return "saySomething";
    }

    function saySomething(string memory something) public pure returns (string memory) {
        return something;
    }

    function f(uint8 _in) public pure returns (uint8 out) {
        out = _in;
    }

    function f(uint256 _in) public pure returns (uint256 out) {
        return out = _in;
    }


}