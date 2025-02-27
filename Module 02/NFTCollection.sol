// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMinter {
    IERC20 public token;
    IERC721 public nft;
    address public owner;
    uint256 public mintPrice = 10 * 10 ** 18;

    constructor(IERC20 _token, IERC721 _nft) {
        token = _token;
        nft = _nft;
        owner = msg.sender;
    }

    function mintNFT(uint256 tokenId) public {
        require(token.transferFrom(msg.sender, address(this), mintPrice), "Token transfer failed");
        nft.safeTransferFrom(owner, msg.sender, tokenId);
    }
}
