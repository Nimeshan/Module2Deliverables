// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTStaking {
    IERC20 public token;
    IERC721 public nft;
    mapping(uint256 => address) public stakedBy;
    mapping(uint256 => uint256) public lastClaim;
    uint256 public rewardPerDay = 10 * 10 ** 18;
    uint256 public stakingTime = 1 minutes; // Tried lower for testing

    constructor(IERC20 _token, IERC721 _nft) {
        token = _token;
        nft = _nft;
    }

    function stakeNFT(uint256 tokenId) public {
        require(nft.ownerOf(tokenId) == msg.sender, "Not the owner");
        require(stakedBy[tokenId] == address(0), "Already staked");
        nft.transferFrom(msg.sender, address(this), tokenId);
        stakedBy[tokenId] = msg.sender;
        lastClaim[tokenId] = block.timestamp;
    }

    function claimRewards(uint256 tokenId) public {
        require(stakedBy[tokenId] == msg.sender, "Not staked by you");
        require(block.timestamp >= lastClaim[tokenId] + stakingTime, "Too soon to claim");
        token.transfer(msg.sender, rewardPerDay);
        lastClaim[tokenId] = block.timestamp;
    }

    function unstakeNFT(uint256 tokenId) public {
        require(stakedBy[tokenId] == msg.sender, "Not staked by you");
        nft.transferFrom(address(this), msg.sender, tokenId);
        delete stakedBy[tokenId];
        delete lastClaim[tokenId];
    }
}
