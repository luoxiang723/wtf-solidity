//pragma solidity ^0.8.0;

// contract C {
//     uint public data = 30;         // 公共状态变量
//     uint internal iData = 10;      // 内部状态变量
//     function x() public returns (uint) {
//         data = 3;                  // 内部访问公共变量
//         return data;
//     }
// }

// contract Caller {
//     C c = new C();
//     function f() public view returns (uint) {
//         return c.data();          // 外部访问公共变量
//     }
// }

// contract D is C {
//     uint storedData;
//     function y() public returns (uint) {
//         iData = 3;               // 派生合约内部访问内部变量
//         return iData;
//     } 
//     function getResult() public view returns(uint) {
//         uint a = 1;               // 局部变量
//         uint b = 2;
//         uint result = a + b;
//         return storedData;        // 访问状态变量
//     }
// }

// pragma solidity >=0.8.0;
// contract ErrorHandlingExample {
//     uint public balance;
//     function sendHalf(address addr) public payable {
//         require(msg.value % 2 == 0, "Even value required."); // 输入检查
//         uint balanceBeforeTransfer = address(this).balance;
//         addr.transfer(msg.value / 2);
//         assert(address(this).balance == balanceBeforeTransfer - msg.value / 2); // 内部错误检查
//     }
// }


// pragma solidity ^0.8.0;
// contract CustomErrorExample {
//     error Unauthorized(address caller);  // 自定义错误  
//     address public owner;
//     constructor() {
//         owner = msg.sender;
//     }
//     function restrictedFunction() public {
//         if (msg.sender != owner) {
//             revert Unauthorized(msg.sender);  // 使用自定义错误
//         }
//     }
// }

// pragma solidity >=0.8.0;
// contract ExternalContract {
//     function getValue() public pure returns (uint) {
//         return 42;
//     }
//     function willRevert() public pure {
//         revert("This function always fails");
//     }
// }
// contract TryCatchExample {
//     ExternalContract externalContract;
//     constructor() {
//         externalContract = new ExternalContract();
//     }
//     function tryCatchTest() public returns (uint, string memory) {
//         try externalContract.getValue() returns (uint value) {
//             return (value, "Success");
//         } catch {
//             return (0, "Failed");
//         }
//     }
//     function tryCatchWithRevert() public returns (string memory) {
//         try externalContract.willRevert() {
//             return "This will not execute";
//         } catch Error(string memory reason) {
//             return reason;  // 捕获错误信息
//         } catch {
//             return "Unknown error";
//         }
//     }
// }


/**
全局变量
1、block.blockhash(uint blockNumber)  返回值:指定区块的哈希，blockNumber仅支持最近的256个区块，且不包括当前区块
2、block.coinbase 返回值类型：address 返回挖出当前区块的矿工地址
3、block.difficulty 返回值类型：uint 返回当前区块的难度
4、block.gaslimit 返回值类型 uint：返回当前区块的Gas上限
5、block.number 返回值类型：uint;返回当前区块号
6、block.timestamp 返回值类型：uint; 返回当前区块的时间戳（单位：秒）

全局函数
1、gasleft()  返回值类型：uint256
2、msg.data  返回值类型： bytes
3、msg.sender  返回值类型：address
4、msg.sig  返回值类型：bytes4
5、msg.value  返回值类型：uint 本次调用发送的以太币数量
6、tx.gaxprice  返回值类型：uint 返回当前交易的gas价格
7、tx.origin  返回值类型：address payable 发挥交易的最初发起者地址

abi
编码
1、abi.encode(...)
2、abi.encodePacked(...)
3、abi.encodeWithSelector(bytes4 selector, ...)
4、abi.encodeWithSignature(string signature)

解码
1、abi.decode(bytes memory encodedData, (...))) returns (...)

数学函数
1、addmod(uint x, uint y, uint k)
2、mulmod(uint x, uint y, uint k)

密码学和哈希函数
1、keccake256(bytes memory) returns (bytes32)
2、sha256(bytes memory) returns (bytes32)
3、ripemd160(bytes memory) returns (bytes32)

椭圆曲线签名恢复
ecrecover(bytes32 hash, uint v, bytes32 r, bytes32 s)

**/

// pragma solidity ^0.8.0;
// contract TimeLock { 
//     uint public unlockTime; 
//     address public owner;
//     constructor(uint _lockTime) { 
//         owner = msg.sender; 
//         unlockTime = block.timestamp + _lockTime * 1 days; // 锁定指定天数 
//     }
//     function withdraw() public { 
//         require(block.timestamp >= unlockTime, "Funds are locked."); 
//         require(msg.sender == owner, "Only owner can withdraw."); // 执行提款操作
//     }
// }


pragma solidity ^0.8.0;

contract ReceiveETH {
    // 收到eth事件，记录amount和gas
    event Log(uint amount, uint gas);
    
    // receive方法，接收eth时被触发
    receive() external payable{
        emit Log(msg.value, gasleft());
    }
    
    // 返回合约ETH余额
    function getBalance() view public returns(uint) {
        return address(this).balance;
    }
}