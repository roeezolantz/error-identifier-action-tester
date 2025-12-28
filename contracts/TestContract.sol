// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

/**
 * @title TestContract
 * @notice A simple contract with various custom errors for testing the error identifier action
 */
contract TestContract {
    address public owner;
    mapping(address => uint256) public balances;
    bool public paused;

    // Custom errors with different parameter types
    error Unauthorized(address caller);
    error InsufficientBalance(uint256 requested, uint256 available);
    error InvalidAddress();
    error ContractPaused();
    error TransferFailed(address from, address to, uint256 amount);
    error InvalidAmount(uint256 amount);
    error AlreadyInitialized();
    error ZeroValue();

    constructor() {
        owner = msg.sender;
        paused = false;
    }

    function deposit() external payable {
        if (paused) revert ContractPaused();
        if (msg.value == 0) revert ZeroValue();

        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        if (paused) revert ContractPaused();
        if (amount == 0) revert InvalidAmount(amount);
        if (balances[msg.sender] < amount) {
            revert InsufficientBalance(amount, balances[msg.sender]);
        }

        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        if (!success) revert TransferFailed(address(this), msg.sender, amount);
    }

    function transfer(address to, uint256 amount) external {
        if (paused) revert ContractPaused();
        if (to == address(0)) revert InvalidAddress();
        if (amount == 0) revert InvalidAmount(amount);
        if (balances[msg.sender] < amount) {
            revert InsufficientBalance(amount, balances[msg.sender]);
        }

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    function pause() external {
        if (msg.sender != owner) revert Unauthorized(msg.sender);
        paused = true;
    }

    function unpause() external {
        if (msg.sender != owner) revert Unauthorized(msg.sender);
        paused = false;
    }
}
