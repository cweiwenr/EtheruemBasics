pragma solidity ^0.4.8;

/**
Another reentrancy example
 */
contract EtherStore {


    // initialize the mutex, protect against reentrancy
    bool reEntrancyMutex = false;

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    // caller to increment their funds
    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    // caller to withdraw their funds 
    function withdrawFunds (uint256 _weiToWithdraw) public {
        // using mutex to protect
        require(!reEntrancyMutex);

        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);

        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        // set the reEntrancy mutex before the external call
        reEntrancyMutex = true;
        msg.sender.transfer(_weiToWithdraw);
        // release the mutex after the external call
        reEntrancyMutex = false;

        /*
        VULNERABLE CODE ORDER, checks-effects-interactions pattern NOT employed
        // vulnerable line, contract sends the user their requested amount of ether
        // thus calling the fallback function of the attack contract
        require(msg.sender.call.value(_weiToWithdraw)());

        // this line will never be executed in an reentraqncy attacks
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        */
    }
 }