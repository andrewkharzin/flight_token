// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract FlightToken is ERC20, Ownable, ERC20Permit {
    // Structure to hold player information
    struct Player {
        uint256 balance;           // How many tokens the player has earned
        uint256 flightsCompleted;  // How many flights/missions they have completed
        bool isRegistered;         // To check if the player is registered
    }

    // Mapping to store player details
    mapping(address => Player) public players;

    // Event for when a player earns tokens
    event TokensEarned(address indexed player, uint256 amount);
    event FlightCompleted(address indexed player, uint256 flightNumber);

   // Constructor that initializes the ERC20 token and sets the owner
   constructor(address initialOwner)
    ERC20("FlightToken", "FLTT")
    Ownable(initialOwner) // Вызов конструктора Ownable с круглой скобкой
    ERC20Permit("FlightToken") // Добавляем конструкцию ERC20Permit, если требуется
{
    transferOwnership(initialOwner);
}

    // Modifier to check if the player is registered
    modifier onlyRegisteredPlayer() { 
        require(players[msg.sender].isRegistered, "Player not registered");
        _;
    }

    // Function to register a new player
    function registerPlayer(address player) public onlyOwner {
        require(!players[player].isRegistered, "Player already registered");
        players[player] = Player(0, 0, true);
    }

    // Function for players to earn tokens by completing flights/missions
    function earnTokens(uint256 amount) public onlyRegisteredPlayer {
        require(amount > 0, "Amount must be greater than zero"); // Ensure non-zero amount
        players[msg.sender].balance += amount;
        players[msg.sender].flightsCompleted += 1;
        _mint(msg.sender, amount);  // Mint tokens to the player
        emit TokensEarned(msg.sender, amount);
        emit FlightCompleted(msg.sender, players[msg.sender].flightsCompleted);
    }

    // Function to burn tokens (players can spend tokens on upgrades or other in-game features)
    function burnTokens(uint256 amount) public onlyRegisteredPlayer {
        require(amount > 0, "Amount must be greater than zero"); // Ensure non-zero amount
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to burn");
        _burn(msg.sender, amount);
        players[msg.sender].balance -= amount;
    }

    // Owner can mint tokens for special rewards or events
    function mint(address to, uint256 amount) public onlyOwner {
        require(amount > 0, "Mint amount must be greater than zero"); // Ensure non-zero amount
        _mint(to, amount);
    }

    // Function to get player stats (balance and flights completed)
    function getPlayerStats(address player) public view returns (uint256, uint256) {
        return (players[player].balance, players[player].flightsCompleted);
    }

    // Security features: allowing owner to freeze token transfers for a specific player (anti-cheating mechanism)
    mapping(address => bool) public frozenAccounts;

    // Function to freeze an account (block token transfers if cheating is detected)
    function freezeAccount(address player) public onlyOwner {
        frozenAccounts[player] = true;
    }

    // Function to unfreeze an account
    function unfreezeAccount(address player) public onlyOwner {
        frozenAccounts[player] = false;
    }

    // Override transfer function to prevent transfers from frozen accounts
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal {
        require(!frozenAccounts[from], "Account is frozen");
        _beforeTokenTransfer(from, to, amount);
        }
}