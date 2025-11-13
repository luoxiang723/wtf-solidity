pragma solidity ^0.8.21;

import {IERC165} from "./IERC165.sol";
import {IERC721} from "./IERC721.sol";
import {IERC721Metadata} from "./IERC721Metadata.sol";
import {IERC721Receiver} from "./IERC721Receiver.sol";
import {Strings} from "./Strings.sol";

contract ERC721 is IERC721, IERC721Metadata {
    using Strings for uint256;

    string public override name;
    string public override symbol;

    mapping(uint256 => address ) public _owners;
    mapping(address => uint256 ) public _balances;
    mapping(uint256 => address ) public _tokenApprovals;
    mapping(address => mapping(address => bool)) public _operatorApprovals;

    error InvaildERC721Receiver(address receiver);

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    /**
    * bytes4(keccak256(ERC721.Transfer.selector) ^ keccak256(ERC721.Approval.selector) ^ ··· ^keccak256(ERC721.isApprovedForAll.selector))
    *
    * bytes4(keccak256(IERC721Metadata.name.selector ^ IERC721Metadata.symbol.selector ^ IERC721Metadata.tokenURI.selector))
    **/
    function supportsInterface(bytes4 interfaceId) external pure override returns (bool){
        return
                interfaceId == type(IERC721).interfaceId ||
                interfaceId == type(IERC165).interfaceId ||
                interfaceId == type(IERC721Metadata).interfaceId;
    }

    function balanceOf (address owner) external view override returns (uint256 balance) {
        require(owner != address(0), "owner is zero address");//无效的零地址
        return _balances[owner];
    }

    function ownerOf(uint tokenId) public view override returns (address owner){
        owner = _owners[tokenId];
        require (owner != address(0), "token does't exist");//不存在的零地址
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external override {
        address owner = ownerOf(tokenId);
        require (_isApprovedOrOwner(owner, msg.sender,tokenId) , "not owner nor approved for all");//转出方需要有代币的所有权或者所有者的授权
        _transfer(from, to, tokenId);
        _checkERC721Received(from, to, tokenId, data);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) external override {
        address owner = ownerOf(tokenId);
        require (_isApprovedOrOwner(owner, msg.sender, tokenId) , "not owner nor approved");//转出方需要有代币的所有权或者所有者的授权
        _transfer(from, to, tokenId);
        _checkERC721Received(from, to, tokenId, bytes(""));
    }

    function transferFrom (address from, address to, uint256 tokenId) external override {
        address owner = ownerOf(tokenId);
        require (_isApprovedOrOwner(owner, msg.sender,tokenId) , "not owner nor approved");//转出方需要有代币的所有权或者所有者的授权
        _transfer(from, to, tokenId);
    }

    function approve(uint256 tokenId, address operator) external override{
        address owner = _owners[tokenId];
        require (owner == msg.sender || _operatorApprovals[owner][operator], "not owner nor approved for all");//非代币所有者不能授权
        _tokenApprovals[tokenId] = operator;
        _approve(owner, operator, tokenId);
    }

    function setApproveAll(address operator, bool approved) external override {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint256 tokenId) external view override returns (address operator) {
        require (ownerOf(tokenId) != address(0), "token doesn't exist"); //不存在的代币
        operator = _tokenApprovals[tokenId];
        //require(operator == address(0), "");//该代币未被授权
    }

    function isApprovedAll(address operator) external view override returns (bool) {
        return _operatorApprovals[msg.sender][operator];
    }

    function _isApprovedOrOwner(address owner, address operator, uint256 tokenId) private view returns (bool) {
        return operator == owner ||
            _tokenApprovals[tokenId] == operator ||
                            _operatorApprovals[owner][operator];

    }

    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) private{
        _transfer(from, to, tokenId);
        _checkERC721Received(from, to, tokenId, data);
    }

    function _transfer (address from, address to, uint256 tokenId) private {
        require (to != address(0), "transfer to the zero address");//不能转入空地址

        _approve(from, address(0), tokenId);

        _owners[tokenId] = to;
        _balances[from] -=1;
        _balances[to] +=1;
        emit Transfer(from, to, tokenId);
    }

    function _approve(address owner, address operator, uint256 tokenId) private {
        _tokenApprovals[tokenId] = operator;
        emit Approval(owner, operator, tokenId);
    }

    function _checkERC721Received(address from, address to, uint256 tokenId, bytes memory data) private {
        if(to.code.length>0){
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
                if (retval != IERC721Receiver.onERC721Received.selector) {
                    revert InvaildERC721Receiver(to);
                }
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert InvaildERC721Receiver(to);
                } else {
                    assembly {
                        // 这段汇编代码没看懂啥意思？
                        revert(add(32, reason), mload(reason))
                    }
                }

            }
        }
    }

    /**
     * 实现IERC721Metadata的tokenURI函数，查询metadata。
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_owners[tokenId] != address(0), "Token Not Exist");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * 计算{tokenURI}的BaseURI，tokenURI就是把baseURI和tokenId拼接在一起，需要开发重写。
     * BAYC的baseURI为ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * 铸造函数。通过调整_balances和_owners变量来铸造tokenId并转账给 to，同时释放Transfer事件。铸造函数。通过调整_balances和_owners变量来铸造tokenId并转账给 to，同时释放Transfer事件。
     * 这个mint函数所有人都能调用，实际使用需要开发人员重写，加上一些条件。
     * 条件:
     * 1. tokenId尚不存在。
     * 2. to不是0地址.
     */
    function _mint(address to, uint tokenId) internal virtual {
        require(to != address(0), "mint to zero address");
        require(_owners[tokenId] == address(0), "token already minted");

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    // 销毁函数，通过调整_balances和_owners变量来销毁tokenId，同时释放Transfer事件。条件：tokenId存在。
    function _burn(uint tokenId) internal virtual {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "not owner of token");

        _approve(owner, address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }



}