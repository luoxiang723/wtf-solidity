// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract OnlyEven {
    constructor(uint a){
        require(a!=0, "invalid number...");
        assert(a!=1);
    }

    function onlyEven(uint256 b) external pure returns (bool success) {
        require(b%2==0 ,"Ups! Reverting");
        success = true;
    }
}

contract OnlyEven2 {
    constructor(uint a){
        require(a!=0, "invalid number...");
        assert(a!=1);
    }

    function onlyEven(uint256 b) external pure returns (uint success) {
        require(b%2==0 ,"Ups! Reverting");
        success = b;
    }
}

contract TryCatch {

    event SuccessEvent();
    event CatchEvent(string msg);
    event CatchByte(bytes data);

    OnlyEven even;

    constructor(){
        even = new OnlyEven(2);
    }

    //execute(0) SuccessEvent()
    //execute(1) CatchEvent("Ups! Reverting")
    function execute(uint amount) external returns (bool success) {
        try even.onlyEven(amount) returns (bool success) {
            emit SuccessEvent();
        } catch Error(string memory reason) {
            emit CatchEvent(reason);
        }
    }

    //executeNew(0) CatchEvent(reason);
    //executeNew(1) CatchByte(reason);
    //executeNew(2) SuccessEvent();
    function executeNew(uint amount) external returns (bool success) {
        try new OnlyEven(amount) returns (OnlyEven onlyEven) {
            emit SuccessEvent();
        } catch Error (string memory reason) {//require
            emit CatchEvent(reason);
        } catch (bytes memory reason) {//assert
            emit CatchByte(reason);
        }
    }

    function executeRevert() external {
        try OnlyEven(address(0)).onlyEven(1) {
            emit SuccessEvent();
        } catch Error (string memory reason) {
            emit CatchEvent(reason);
        } catch (bytes memory reason) {
            emit CatchByte(reason);
        }
    }

    function executeRevertTest() external returns (bool success) {
        address onlyEven2 = address(new OnlyEven(2));
        uint256 amount=2;
        try OnlyEven(onlyEven2).onlyEven(amount) returns (bool _success) {
            emit SuccessEvent();
        } catch Error (string memory reason) {
            emit CatchEvent(reason);
        } catch (bytes memory reason) {
            emit CatchByte(reason);
        }
    }

    function executeRevert2() external returns (bool success) {
        address onlyEven2 = address(new OnlyEven2(2));
        uint256 amount=2;
        try OnlyEven(onlyEven2).onlyEven(amount) returns (bool _success) {
            emit SuccessEvent();
        } catch Error (string memory reason) {
            emit CatchEvent(reason);
        } catch (bytes memory reason) {
            emit CatchByte(reason);
        }
    }
}
