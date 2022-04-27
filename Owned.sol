pragma solidity ^0.6.4;

contract Owned {
    address payable owner;

    // Contract constructor: set owner
    constructor() public {
        owner = msg.sender;
    }
    // function modifier
    // this is an extremely important and useful tool
    // However, modifiers are pervasive, Vyper has done away with modifiers altogether. 
    // If doing simple assertions, just do inline as part of function
    // If modifying smart contract state and so forth, make these changes explicitly part of the function
    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can call this function");
        // this underscore is a placeholder and will be replaced by the code of the function
        // that is being modified
        _;
    }
}