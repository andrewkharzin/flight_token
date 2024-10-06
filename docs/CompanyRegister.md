# Solidity API

## CompanyRegistry

### Contract
CompanyRegistry : contracts/company/CompanyRegister.sol

 --- 
### Modifiers:
### onlyOwner

```solidity
modifier onlyOwner()
```

### onlyExistingCompany

```solidity
modifier onlyExistingCompany(uint256 companyId)
```

 --- 
### Functions:
### constructor

```solidity
constructor() public
```

### registerCompany

```solidity
function registerCompany(string _name, string _registrationNumber, address _wallet) public
```

### updateCompany

```solidity
function updateCompany(uint256 _companyId, string _name, string _registrationNumber, bool _isActive) public
```

### getCompany

```solidity
function getCompany(uint256 _companyId) public view returns (string, string, address, bool)
```

### getCompanyByWallet

```solidity
function getCompanyByWallet(address _wallet) public view returns (string, string, address, bool)
```

### removeCompany

```solidity
function removeCompany(uint256 _companyId) public
```

 --- 
### Events:
### CompanyRegistered

```solidity
event CompanyRegistered(uint256 companyId, string name, string registrationNumber, address wallet)
```

### CompanyUpdated

```solidity
event CompanyUpdated(uint256 companyId, string name, string registrationNumber, bool isActive)
```

