pragma solidity ^0.6.4;

import "Owned.sol";

contract Mortal is Owned {
    // Contract destructor
    // you can read this as only the owner can use this destroy function
    function destroy() public onlyOwner {

        // ensure only owner of contract can call
        // require(msg.sender == owner); I can remove this now as I have applied modifier 'onlyOwner' to the function
        // transfer any funds to owner before destroying contract account
        selfdestruct(owner);
    }
}