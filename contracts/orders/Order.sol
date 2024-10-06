// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Order is Ownable {
    enum OrderStatus { Pending, InProgress, Completed, Cancelled }

    // Structure to represent an order
    struct ServiceOrder {
        uint256 id;                    // Unique identifier for the order
        address customer;              // Address of the customer
        string serviceType;            // Type of service requested
        uint256 amount;                // Amount charged for the service
        OrderStatus status;            // Current status of the order
        uint256 createdAt;             // Timestamp when the order was created
    }

    // Mapping to store orders by their ID
    mapping(uint256 => ServiceOrder) public orders;
    // Counter for generating unique order IDs
    uint256 public orderCount;

    // Event to emit when an order is created
    event OrderCreated(uint256 indexed id, address indexed customer, string serviceType, uint256 amount, uint256 createdAt);
    
    // Event to emit when an order status is updated
    event OrderStatusUpdated(uint256 indexed id, OrderStatus status);

    // Function to create a new order
    function createOrder(string memory serviceType, uint256 amount) external {
        orderCount++;
        orders[orderCount] = ServiceOrder(orderCount, msg.sender, serviceType, amount, OrderStatus.Pending, block.timestamp);
        
        emit OrderCreated(orderCount, msg.sender, serviceType, amount, block.timestamp);
    }

    // Function to update the status of an order
    function updateOrderStatus(uint256 id, OrderStatus status) external onlyOwner {
        require(orders[id].id != 0, "Order does not exist");
        
        orders[id].status = status;
        
        emit OrderStatusUpdated(id, status);
    }

    // Function to get order details
    function getOrderDetails(uint256 id) external view returns (ServiceOrder memory) {
        require(orders[id].id != 0, "Order does not exist");
        return orders[id];
    }
}
