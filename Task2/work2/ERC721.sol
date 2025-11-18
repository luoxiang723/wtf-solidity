// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {IERC721} from "./IERC721.sol";
import {IERC721Metadata} from "./IERC721Metadata.sol";
import {IERC165} from "./IERC165.sol";
import {IERC721Receiver} from "./IERC721Receiver.sol";
import {Strings} from "./Strings.sol";

contract ERC721 is IERC721, IERC721Metadata {

    using Strings for uint256;

    string public name;
    string public symbol;
    mapping( uint256 => address) private _owners;
    mapping( address => uint256) private _balanceOf;
    mapping( uint256 => address) private _tokenApprovals;
    mapping( address => mapping(address => bool)) private _operatorApprovals;
    

    error ERC721InvalidReceiver(address receiver);

    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
    }


    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_owners[tokenId] != address(0), "token not exist"); 
        string memory baseURI = _baseURI();
        return bytes(baseURI).length>0? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[ERC section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == type(IERC721).interfaceId ||
                interfaceId == type(IERC165).interfaceId ||
                interfaceId == type(IERC721Metadata).interfaceId;
    }

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) public view override returns (uint256 balance) {
        return _balanceOf[owner];
    }

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view override returns (address owner) {
        owner = _owners[tokenId];
        require(owner != address(0), "token not exist");
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external override  {
        require(_checkOwnedOrApproved(from, to, tokenId), "`tokenId` token must exist and be owned by `from` or `from` must be approved to move this token by either approve or setApprovalForAll");
        _checkERC721Receiver(from, to, tokenId, data);
        _transfer(from, to, tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) private {
        _balanceOf[from] -= 1;
        _balanceOf[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);

        _tokenApprovals[tokenId] = address(0);
        emit Approval(to, address(0), tokenId);
    }

    function _checkOwnedOrApproved(address from, address to, uint256 tokenId) private view returns (bool) {
        require(from != address(0), "`from` cannot be the zero address");
        require(to != address(0), "`to` cannot be the zero address");
        address owner = _owners[tokenId];
        require(owner != address(0), "token not exist");
        address approved = _tokenApprovals[tokenId];
        return owner == from || approved == msg.sender || _operatorApprovals[from][msg.sender];
    }

    function _checkERC721Receiver(address from, address to, uint256 tokenId, bytes memory data) private {
        if(to.code.length > 0){
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
                if(retval != IERC721Receiver.onERC721Received.selector){
                    revert ERC721InvalidReceiver(to);
                }
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert ERC721InvalidReceiver(to);
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        }
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC-721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or
     *   {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external override {
        require(_checkOwnedOrApproved(from, to, tokenId), "`tokenId` token must exist and be owned by `from` or `from` must be approved to move this token by either approve or setApprovalForAll");
        _checkERC721Receiver(from, to, tokenId, bytes(""));
        _transfer(from, to, tokenId);
    }

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC-721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external override {
        _checkERC721Receiver(from, to, tokenId, bytes(""));
        _transfer(from, to, tokenId);
    }

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external override {
        address owner = _owners[tokenId];
        require(_owners[tokenId] != address(0), "token not exist");
        require(msg.sender == owner, "The caller must own the token or be an approved operator");
        _tokenApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the address zero.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external override {
        require(operator != address(0),  "The `operator` cannot be the address zero.");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view override  returns (address operator) {
        require(_owners[tokenId] != address(0), "token not exist");
        return _tokenApprovals[tokenId];
    }

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function _mint(address to, uint256 tokenId) internal  {
        require(to != address(0), "`to` cannot be the zero address");
        require(_owners[tokenId] == address(0), "token has been minted");
        _owners[tokenId] = to;
        _balanceOf[to] += 1;
        emit Transfer(address(0), to, tokenId);
    }
}