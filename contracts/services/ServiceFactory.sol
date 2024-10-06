// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Service.sol";

contract ServiceFactory {
    // Массив для хранения всех созданных услуг
    Service[] public services;

    // Событие для отслеживания создания новой услуги
    event ServiceCreated(address serviceAddress, string name, uint256 price);

    // Функция для создания новой услуги
    function createService(string memory _name, uint256 _price) public {
        // Create a new contract service
        Service newService = new Service(_name);

        // Add it to the array of created services
        services.push(newService);

        // Emit the event
        emit ServiceCreated(address(newService), _name, _price);
    }

    // Функция для получения количества созданных услуг
    function getServicesCount() public view returns (uint256) {
        return services.length;
    }

    // Функция для получения информации о конкретной услуге
    function getService(uint256 _index) public view returns (address, string memory, uint256) {
        require(_index < services.length, "Service does not exist");
        Service service = services[_index];
        return (address(service), service.name(), service.price());
    }
}
