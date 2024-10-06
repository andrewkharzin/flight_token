// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Company {
    // Структура для хранения информации о компании
    struct CompanyInfo {
        string name;         // Название компании
        string registrationNumber;  // Регистрационный номер компании
        address wallet;      // Адрес кошелька компании
        bool isActive;       // Статус активности компании
    }

    // Маппинг для хранения компаний по адресу кошелька
    mapping(address => CompanyInfo) public companies;
    
    // Адрес владельца (администратор контракта)
    address public owner;
    
    // Мероприятие для регистрации компании
    event CompanyRegistered(address indexed wallet, string name, string registrationNumber);
    
    // Мероприятие для обновления информации о компании
    event CompanyUpdated(address indexed wallet, string name, string registrationNumber, bool isActive);
    
    // Модификатор для проверки владельца
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Модификатор для проверки, что компания существует
    modifier onlyExistingCompany(address companyAddress) {
        require(companies[companyAddress].wallet != address(0), "Company does not exist");
        _;
    }
    
    constructor() {
        owner = msg.sender;  // Владелец контракта
    }
    
    // Функция для регистрации новой компании
    function registerCompany(string memory _name, string memory _registrationNumber, address _wallet) public onlyOwner {
        require(companies[_wallet].wallet == address(0), "Company already registered");

        companies[_wallet] = CompanyInfo({
            name: _name,
            registrationNumber: _registrationNumber,
            wallet: _wallet,
            isActive: true
        });
        
        emit CompanyRegistered(_wallet, _name, _registrationNumber);
    }
    
    // Функция для обновления данных компании
    function updateCompany(string memory _name, string memory _registrationNumber, address _wallet, bool _isActive)
        public
        onlyOwner
        onlyExistingCompany(_wallet)
    {
        CompanyInfo storage company = companies[_wallet];
        company.name = _name;
        company.registrationNumber = _registrationNumber;
        company.isActive = _isActive;

        emit CompanyUpdated(_wallet, _name, _registrationNumber, _isActive);
    }
    
    // Функция для получения информации о компании
    function getCompany(address _wallet) public view returns (string memory, string memory, address, bool) {
        CompanyInfo memory company = companies[_wallet];
        return (company.name, company.registrationNumber, company.wallet, company.isActive);
    }

    // Функция для удаления компании (может понадобиться)
    function removeCompany(address _wallet) public onlyOwner onlyExistingCompany(_wallet) {
        delete companies[_wallet];
    }
}
