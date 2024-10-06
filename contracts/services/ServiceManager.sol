// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../company/CompanyRegistry.sol"; 
import "./Service.sol";

contract ServiceManager {
    // Структура для хранения информации о заказах на услуги
    struct ServiceRequest {
        uint256 serviceId;        // ID услуги
        uint256 companyId;        // ID компании, которая делает запрос
        uint256 quantity;         // Количество заказанных единиц услуги
        uint256 totalPrice;       // Итоговая стоимость запроса на услугу
        bool isApproved;          // Статус одобрения
        bool isCompleted;         // Статус выполнения
    }

    // Маппинг для хранения всех заказов на услуги
    mapping(uint256 => ServiceRequest) public serviceRequests;

    // Счетчик ID для запросов на услуги
    uint256 public requestCount;

    // Ссылка на контракт CompanyRegistry и Service
    CompanyRegistry public companyRegistry;
    Service public serviceContract;

    // Адрес владельца контракта
    address public owner;

    // События
    event ServiceRequested(uint256 indexed requestId, uint256 indexed serviceId, uint256 companyId, uint256 quantity, uint256 totalPrice);
    event ServiceApproved(uint256 indexed requestId);
    event ServiceCompleted(uint256 indexed requestId);

    // Модификатор для проверки прав владельца
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
    constructor(address companyRegistryAddress, address serviceContractAddress) {
        owner = msg.sender; // Владелец контракта
        companyRegistry = CompanyRegistry(companyRegistryAddress); // Инициализация CompanyRegistry контракта
        serviceContract = Service(serviceContractAddress); // Инициализация Service контракта
    }

    // Функция для создания запроса на услугу
    function requestService(uint256 _companyId, uint256 _serviceId, uint256 _quantity) 
        public 
        onlyExistingCompany(_companyId)
    {
        (, uint256 price, bool isActive) = serviceContract.getService(_serviceId);
        require(isActive, "Service is not active");

        requestCount++;
        uint256 totalPrice = price * _quantity;

        serviceRequests[requestCount] = ServiceRequest({
            serviceId: _serviceId,
            companyId: _companyId,
            quantity: _quantity,
            totalPrice: totalPrice,
            isApproved: false,
            isCompleted: false
        });

        emit ServiceRequested(requestCount, _serviceId, _companyId, _quantity, totalPrice);
    }

    // Функция для одобрения запроса на услугу
    function approveServiceRequest(uint256 _requestId) public onlyOwner {
        require(!serviceRequests[_requestId].isApproved, "Request is already approved");
        serviceRequests[_requestId].isApproved = true;

        emit ServiceApproved(_requestId);
    }

    // Функция для выполнения услуги
    function completeServiceRequest(uint256 _requestId) public onlyOwner {
        require(serviceRequests[_requestId].isApproved, "Request must be approved first");
        require(!serviceRequests[_requestId].isCompleted, "Request is already completed");

        serviceRequests[_requestId].isCompleted = true;

        // Вызов функции выполнения услуги в контракте Service
        serviceContract.completeService(_requestId);

        emit ServiceCompleted(_requestId);
    }

    // Функция для получения информации о запросе на услугу
    function getServiceRequest(uint256 _requestId) public view returns (uint256, uint256, uint256, uint256, bool, bool) {
        ServiceRequest memory request = serviceRequests[_requestId];
        return (
            request.serviceId,
            request.companyId,
            request.quantity,
            request.totalPrice,
            request.isApproved,
            request.isCompleted
        );
    }
}
