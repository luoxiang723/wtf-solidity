// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {ERC721} from "./ERC721.sol";

contract LXApe is ERC721 {

    uint256 public MAX_APES = 10000;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){
    }

    function _baseURI() internal pure override returns (string memory) {
        //bafkreib3knhd2yzwbb66ccezx5236ej3dvrogqes5movzmeukpfdsfdshu
        return "ipfs://bafkreib3knhd2yzwbb66ccezx5236ej3dvrogqes5movzmeukpfdsfdshu/";
    }

    function mintNFT(address to, uint256 tokenId) external {
        require(tokenId < MAX_APES, "tokenId out of range");
        _mint(to, tokenId);
    }
}