pragma solidity ^0.8.0;

interface IERC165 {
    /**
     * @dev 如果合约实现了查询 `interfaceId`，则返回true
    */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}