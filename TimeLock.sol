pragma solidity ^0.4.8;

/**
To secure against arithmetic over/underflow attacks, use openzepplin's safe math library
https://github.com/OpenZeppelin/openzeppelin-contracts
https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v1.12.0/contracts/math/SafeMath.sol
It replaces the standard math operators, add sub and multiply such that it does not cause over/underflows in EVM
 */
library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // This holds in all cases
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
Contract that is vulnerable to arithmetic over/underflow
Contract allows user to lock their ether for a period of time as defined
in the map variables balances and lockTime. Useful when users need to hand over their
private keys and wants to prevent access to their funds. However attackers can use
arithmatic over/underflow to still withdraw ether
 */
contract TimeLock {
    
    // Secure against arithmetic overunderflow
    using SafeMath for uint; // use the library for uint type

    mapping(address => uint) public balances;

    /**
    Since lockTime variable is public, attackers can access this variable to get remaining
    time left for lock period. 
     */
    mapping(address => uint) public lockTime;

    // Let users deposit their ether, lock it up for 1 week
    function deposit() public payable {
        
        // Insecure code using standard math ops
        /**
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = now + 1 weeks;
         */

         // Secured code using openzepplin's math ops
        balances[msg.sender] = balances[msg.sender].add(msg.value);
        lockTime[msg.sender] = now.add(1 weeks);

    }

    /**
    allows attacker to increase the locktime. But it is unsafe as it is uint256 and susceptible to 
    overflow attacks. Attackers can pass in the argument w**256 - userLockTime to set the lockTime as
    0 using uint256 overflow. Then the attacker can simply withdraw the funds using the withdraw function
     */
    function increaseLockTime(uint _secondsToIncrease) public {
        
        /**
        // insecure code
        lockTime[msg.sender] += _secondsToIncrease;
         */
        
        // secure
        lockTime[msg.sender] = lockTime[msg.sender].add(_secondsToIncrease);
    }

    function withdraw() public {
        require(balances[msg.sender] > 0);
        require(now > lockTime[msg.sender]);
        balances[msg.sender] = 0;
        msg.sender.transfer(balance);
    }
}