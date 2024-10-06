// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CompanyRegistry {
    // Структура для хранения информации о компании
    struct Company {
        string name;              // Название компании
        string registrationNumber; // Регистрационный номер компании
        address wallet;           // Адрес кошелька компании
        bool isActive;            // Статус активности компании
    }

    // Маппинг для хранения компаний по ID
    mapping(uint256 => Company) public companies;
    
    // Счетчик для присвоения уникального ID каждой компании
    uint256 public companyCount;

    // Маппинг для хранения кошельков компаний и их ID
    mapping(address => uint256) public companyIds;

    // Адрес владельца (администратор контракта)
    address public owner;

    // Событие при регистрации компании
    event CompanyRegistered(uint256 indexed companyId, string name, string registrationNumber, address wallet);
    
    // Событие при обновлении данных компании
    event CompanyUpdated(uint256 indexed companyId, string name, string registrationNumber, bool isActive);
    
    // Модификатор для проверки прав владельца контракта
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Модификатор для проверки существования компании
    modifier onlyExistingCompany(uint256 companyId) {
        require(bytes(companies[companyId].name).length != 0, "Company does not exist");
        _;
    }

    constructor() {
        owner = msg.sender; // Владелец контракта
    }

    // Функция для регистрации новой компании
    function registerCompany(string memory _name, string memory _registrationNumber, address _wallet) public onlyOwner {
        require(companyIds[_wallet] == 0, "Company already registered");

        companyCount++;  // Увеличиваем счетчик компаний

        companies[companyCount] = Company({
            name: _name,
            registrationNumber: _registrationNumber,
            wallet: _wallet,
            isActive: true
        });

        companyIds[_wallet] = companyCount;  // Привязываем кошелек к ID компании

        emit CompanyRegistered(companyCount, _name, _registrationNumber, _wallet);
    }

    // Функция для обновления данных компании
    function updateCompany(uint256 _companyId, string memory _name, string memory _registrationNumber, bool _isActive) 
        public 
        onlyOwner 
        onlyExistingCompany(_companyId) 
    {
        Company storage company = companies[_companyId];
        company.name = _name;
        company.registrationNumber = _registrationNumber;
        company.isActive = _isActive;

        emit CompanyUpdated(_companyId, _name, _registrationNumber, _isActive);
    }

    // Функция для получения информации о компании по ID
    function getCompany(uint256 _companyId) public view returns (string memory, string memory, address, bool) {
        Company memory company = companies[_companyId];
        return (company.name, company.registrationNumber, company.wallet, company.isActive);
    }

    // Функция для получения информации о компании по адресу кошелька
    function getCompanyByWallet(address _wallet) public view returns (string memory, string memory, address, bool) {
        uint256 companyId = companyIds[_wallet];
        require(companyId != 0, "Company not found");

        Company memory company = companies[companyId];
        return (company.name, company.registrationNumber, company.wallet, company.isActive);
    }

    // Функция для удаления компании
    function removeCompany(uint256 _companyId) public onlyOwner onlyExistingCompany(_companyId) {
        delete companyIds[companies[_companyId].wallet];  // Удаляем привязку кошелька
        delete companies[_companyId];  // Удаляем компанию из маппинга
    }
}
