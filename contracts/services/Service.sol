// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../company/CompanyRegistry.sol"; 

contract Service {
    // Структура для хранения информации об услуге
    struct ServiceType {
        string name;   // Название услуги
        uint256 price;        // Цена за единицу услуги
        bool isActive;        // Статус активности услуги
    }

    // Структура для хранения информации о заказанной услуге
    struct ServiceOrder {
        uint256 serviceId;        // ID услуги
        uint256 companyId;        // ID компании, которая заказывает услугу
        uint256 quantity;         // Количество заказанных единиц услуги
        uint256 totalPrice;       // Итоговая стоимость услуги
        bool isCompleted;         // Статус выполнения услуги
    }

    // Маппинг для хранения услуг по ID
    mapping(uint256 => ServiceType) public services;
    
    // Маппинг для хранения заказов на услуги
    mapping(uint256 => ServiceOrder) public serviceOrders;
    
    // Счетчики для ID услуг и заказов
    uint256 public serviceCount;
    uint256 public serviceOrderCount;

    // Адрес владельца (администратор контракта)
    address public owner;

    // События
    event ServiceCreated(uint256 indexed serviceId, string serviceName, uint256 price);
    event ServiceOrdered(uint256 indexed orderId, uint256 indexed serviceId, uint256 companyId, uint256 quantity, uint256 totalPrice);
    event ServiceCompleted(uint256 indexed orderId);

    // Ссылка на контракт реестра компаний
    CompanyRegistry public companyRegistry;

    // Модификатор для проверки прав владельца контракта
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Модификатор для проверки существования компании
    modifier onlyExistingCompany(uint256 companyId) {
        (, , , bool isActive) = companyRegistry.getCompany(companyId);
        require(isActive, "Company does not exist or is inactive");
        _;
    }

    // Конструктор
    constructor(address companyRegistryAddress) {
        owner = msg.sender; // Владелец контракта
        companyRegistry = CompanyRegistry(companyRegistryAddress); // Инициализация CompanyRegistry контракта
    }

    // Функция для добавления нового типа услуги
    function addService(string memory _serviceName, uint256 _price) public onlyOwner {
        serviceCount++;
        services[serviceCount] = ServiceType({
            serviceName: _serviceName,
            price: _price,
            isActive: true
        });

        emit ServiceCreated(serviceCount, _serviceName, _price);
    }

    // Функция для обновления цены услуги
    function updateServicePrice(uint256 _serviceId, uint256 _newPrice) public onlyOwner {
        require(services[_serviceId].isActive, "Service is not active");
        services[_serviceId].price = _newPrice;
    }

    // Функция для отключения услуги
    function deactivateService(uint256 _serviceId) public onlyOwner {
        services[_serviceId].isActive = false;
    }

    // Функция для заказа услуги компанией
    function orderService(uint256 _companyId, uint256 _serviceId, uint256 _quantity)
        public
        onlyExistingCompany(_companyId)
    {
        require(services[_serviceId].isActive, "Service is not active");

        serviceOrderCount++;
        uint256 totalPrice = services[_serviceId].price * _quantity;

        serviceOrders[serviceOrderCount] = ServiceOrder({
            serviceId: _serviceId, 
            companyId: _companyId,
            quantity: _quantity,
            totalPrice: totalPrice,
            isCompleted: false
        });

        emit ServiceOrdered(serviceOrderCount, _serviceId, _companyId, _quantity, totalPrice);
    }

    // Функция для завершения выполнения услуги
    function completeService(uint256 _orderId) public onlyOwner {
        require(!serviceOrders[_orderId].isCompleted, "Service order already completed");
        serviceOrders[_orderId].isCompleted = true;
        emit ServiceCompleted(_orderId);
    }

    // Функция для получения информации о заказе
    function getOrder(uint256 _orderId) public view returns (uint256, uint256, uint256, uint256, bool) {
        ServiceOrder memory order = serviceOrders[_orderId];
        return (
            order.serviceId,
            order.companyId,
            order.quantity,
            order.totalPrice,
            order.isCompleted
        );
    }

    // Функция для получения информации о типе услуги
    function getService(uint256 _serviceId) public view returns (string memory, uint256, bool) {
        ServiceType memory service = services[_serviceId];
        return (service.serviceName, service.price, service.isActive);
    }
}
