pragma solidity ^0.8.21;

contract ReceiveETH {
    event ReceiveEth(uint amout, uint gas);

    receive() external payable {
        emit ReceiveEth(msg.value, gasleft());
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
}

error CallFailed();
error SendFailed();

contract SendETH {
    //call
    function callETH(address to, uint amout) external payable {
        (bool success, )= to.call{value: amout}("");
        if(!success){
            revert CallFailed();
        }
    }

    //transfer
    function transferETH(address payable to, uint amt) external payable {
        to.transfer(amt);
    }

    //send
    function sendETH(address payable to, uint amt) external payable {
        bool success = to.send(amt);
        if(!success){
            revert SendFailed();
        }
    }
}