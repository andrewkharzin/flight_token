// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Order.sol";

contract OrderFactory {
    // Mapping to keep track of orders created by each customer
    mapping(address => uint256[]) public customerOrders;

    // Array to store all deployed orders
    Order[] public deployedOrders;

    // Event emitted when a new order is created
    event OrderCreated(address indexed customer, uint256 indexed orderId);

    // Function to create a new order
    function createOrder(string memory serviceType, uint256 amount) external {
        // Create a new Order contract
        Order newOrder = new Order();
        
        // Create the order within the new Order contract
        newOrder.createOrder(serviceType, amount);
        
        // Store the reference to the new order
        deployedOrders.push(newOrder);
        
        // Store the order ID in the customer's order list
        customerOrders[msg.sender].push(newOrder.orderCount());
        
        emit OrderCreated(msg.sender, newOrder.orderCount());
    }

    // Function to get all orders for a customer
    function getCustomerOrders() external view returns (uint256[] memory) {
        return customerOrders[msg.sender];
    }

    // Function to get all deployed orders
    function getAllOrders() external view returns (Order[] memory) {
        return deployedOrders;
    }
}
