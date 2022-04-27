/*
A solidity contract implementing a faucet
Guided by https://github.com/ethereumbook/ethereumbook/blob/develop/code/Solidity/Faucet.sol
This contract is flawed and demonstrates a number of bad practices and security vulnerabilities
 */

// old version
pragma solidity ^0.6.4;

import "Mortal.sol";

// Define contract usually the same name as the file name
contract Faucet is Mortal {

    // define events
    // events will be used to log any withdrawals and deposits
    event Withdrawal(address indexed to, uint amount);
	event Deposit(address indexed from, uint amount);

    // Accept any incoming amount
    receive() external payable {}

    /*
    @params S.I. unit wei
    1 eth = 10**18 wei
     */
    function withdraw(uint withdraw_amount) public {


        require(withdraw_amount <= 0.1 ether); //test precondition like asp.net's contracts
        require(this.balance >= withdraw_amount, "Insufficient balance in faucet for withdrawal request");


        // actual withdrawal
        // msg object are one of the inputs that contracrs can access
        // it represents a transaction that triggered the execution of this contract
        // sender is the sender address fo the transaction
        // transfer transfers the amount in wei to the sender address who initiated this transaction
        msg.sender.transfer(withdraw_amount);

        // call the event to emit to log
        emit Withdrawal(msg.sender, withdraw_amount);
    }

    function () public payable {
        emit Deposit(msg.sender, msg.value);
    }
    
}

