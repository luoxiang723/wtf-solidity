pragma solidity ^0.8.0;

import {IERC165} from "./IERC165.sol";

/**
 * @dev ERC721标准接口
 */
interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed operator, uint indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool indexed approved);

    function balanceOf (address owner) external  view returns (uint256 balance);

    function ownerOf(uint tokenId) external view returns (address owner);

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    function transferFrom (address from, address to, uint256 tokenId) external;

    function approve(uint256 tokenId, address operator) external;

    function setApproveAll(address operator, bool approved) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    function isApprovedAll(address operator) external view returns (bool);

}