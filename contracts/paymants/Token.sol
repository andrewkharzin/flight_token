// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract Token is ERC20, Ownable, ERC20Burnable, ERC20Permit {
    // Constructor that initializes the ERC20 token and sets the owner
    constructor(address initialOwner) 
        ERC20("ServiceToken", "STKN")
        ERC20Permit("ServiceToken") 
    {
        transferOwnership(initialOwner);
    }

    // Function to mint new tokens, can only be called by the owner
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // Optional: Override the transfer function to add additional features if needed
    // You can implement features like freezing accounts, pausing transfers, etc.
    // function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
    //     super._beforeTokenTransfer(from, to, amount);
    // }
}
