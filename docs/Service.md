# Solidity API

## Service

### Contract
Service : contracts/services/Service.sol

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
constructor(address companyRegistryAddress) public
```

### addService

```solidity
function addService(string _serviceName, uint256 _price) public
```

### updateServicePrice

```solidity
function updateServicePrice(uint256 _serviceId, uint256 _newPrice) public
```

### deactivateService

```solidity
function deactivateService(uint256 _serviceId) public
```

### orderService

```solidity
function orderService(uint256 _companyId, uint256 _serviceId, uint256 _quantity) public
```

### completeService

```solidity
function completeService(uint256 _orderId) public
```

### getOrder

```solidity
function getOrder(uint256 _orderId) public view returns (uint256, uint256, uint256, uint256, bool)
```

### getService

```solidity
function getService(uint256 _serviceId) public view returns (string, uint256, bool)
```

 --- 
### Events:
### ServiceCreated

```solidity
event ServiceCreated(uint256 serviceId, string serviceName, uint256 price)
```

### ServiceOrdered

```solidity
event ServiceOrdered(uint256 orderId, uint256 serviceId, uint256 companyId, uint256 quantity, uint256 totalPrice)
```

### ServiceCompleted

```solidity
event ServiceCompleted(uint256 orderId)
```

