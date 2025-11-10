pragma solidity ^0.8.21;

contract Yeye {
    //定义一个事件
    event Log(string msg);

    function hip() public virtual {
        emit Log("Yeye hip");
    }

    function pop() public virtual {
        emit Log("Yeye pop");
    }

    function yeye() public virtual {
        emit Log("Yeye yeye");
    }
}