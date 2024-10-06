// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Payment is Ownable {
    // Mapping to keep track of payments made by customers
    mapping(uint256 => PaymentDetails) public payments;

    // Structure to hold payment details
    struct PaymentDetails {
        address payer;       // Address of the customer who made the payment
        uint256 amount;      // Amount paid
        uint256 serviceId;   // ID of the service for which the payment was made
        bool completed;      // Status of the payment
    }

    // Event emitted when a payment is made
    event PaymentMade(address indexed payer, uint256 indexed serviceId, uint256 amount);

    // Function to make a payment
    function makePayment(uint256 serviceId, uint256 amount, address tokenAddress) external {
        require(amount > 0, "Payment amount must be greater than zero");
        
        // Transfer tokens from the payer to this contract
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);

        // Store payment details
        payments[serviceId] = PaymentDetails({
            payer: msg.sender,
            amount: amount,
            serviceId: serviceId,
            completed: true
        });

        emit PaymentMade(msg.sender, serviceId, amount);
    }

    // Function to withdraw funds from the contract (only owner can withdraw)
    function withdraw(address tokenAddress) external onlyOwner {
        uint256 balance = IERC20(tokenAddress).balanceOf(address(this));
        require(balance > 0, "No funds to withdraw");
        
        // Transfer the balance to the owner's address
        IERC20(tokenAddress).transfer(msg.sender, balance);
    }

    // Function to get payment details by service ID
    function getPaymentDetails(uint256 serviceId) external view returns (PaymentDetails memory) {
        return payments[serviceId];
    }
}
