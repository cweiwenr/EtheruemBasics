pragma solidity ^0.4.8;


/**
This is an example for reentrancy attack taken from 
https://gus-tavo-guim.medium.com/reentrancy-attack-on-smart-contracts-how-to-identify-the-exploitable-and-an-example-of-an-attack-4470a2d8dfe4
This contract keeps a record of balances for each address that put() ether in it
allows address to get() ether deposited in it
 */
contract HoneyPot {
    /**
    maps addresses to a alue and store it in variable called balances
    this allows honeypot to check balances of an address by iterating through the map
    i.e. balances[0x675dbd6a9c17E15459eD31ADBc8d071A78B0BF60] gives the uint value for that address
     */
    mapping (address => uint) public balances;  
    
    function HoneyPot() payable {
        put();
    }  
    
    /**
    whichever wallet(address) that calls put() will record their balance in the map
    msg.sender is the address of the transaction originator
     */
    function put() payable {
        balances[msg.sender] = msg.value;
    }  

    /**
    This is the exploitable function. Since the contract only sets balance to 0 after the check,
    if the AttackContract can trick HoneyPot into thinking it still has ether to withdraw before
    AttackContract balance is set to 0, AttackContract can keep calling the contract to send ether
    from the checking function
    This is done in a recursive manner lets see how we can do this using honeypotcollect
     */
    function get() {

        // check if sending ether to msg.sender goes through
        if (!msg.sender.call.value(balances[msg.sender])()) {
            throw;
        }
        // only set balance after checking
        balances[msg.sender] = 0;
    }  
    
    function() {
        throw;
    }
}