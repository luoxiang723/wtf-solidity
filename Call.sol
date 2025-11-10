pragma solidity ^0.8.21;

contract OtherContract {

    uint256 private x;

    event Log( uint amount, uint gasleft);
    event FallbackLog(address sender, uint amount, bytes data);

    fallback() external payable {
        emit FallbackLog(msg.sender, msg.value, msg.data);
    }

    function setX(uint256 _x) external payable {
        x = _x;
        if (msg.value > 0) {
            emit Log(msg.value, gasleft());
        }
    }

    function getX() external view returns (uint256) {
        return x;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract CallContract {
    event Response (bool success, bytes data);

    function callSetX(address payable  _addr, uint256 x) external payable  {
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("setX(uint256)", x)
        );
        emit Response(success, data);
    }

    function callGetX(address _addr) external returns (uint256){
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("getX()")
        );
        emit Response(success, data);
        require(success, "Call to getX failed");
        return abi.decode(data, (uint256));
    }

    function callNotExist(address _addr) external {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("foo()")
        );
        emit Response(success, data);
    }
}

