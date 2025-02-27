// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./MyNFT.sol"; // Import the MyNFT contract

contract MintingContract {
    IERC20 public token;
    MyNFT public nft;
    uint256 public mintPrice = 10 * 10**18; // 10 ERC20 tokens

    constructor(address _token, address _nft) {
        token = IERC20(_token);
        nft = MyNFT(_nft);
    }

    function mint(string memory tokenURI) public {
        require(token.transferFrom(msg.sender, address(this), mintPrice), "Payment failed");
        nft.mintNFT(msg.sender, tokenURI);
    }
}
