pragma solidity ^0.4.8;

contract EtherGame {

    uint public payoutMileStone1 = 3 ether;
    uint public mileStone1Reward = 2 ether;
    uint public payoutMileStone2 = 5 ether;
    uint public mileStone2Reward = 3 ether;
    uint public finalMileStone = 10 ether;
    uint public finalReward = 5 ether;

    // Security fix
    uint public depositedWei;

    mapping(address => uint) redeemableEther;
    // Users pay 0.5 ether. At specific milestones, credit their accounts.
    function play() public payable {
        require(msg.value == 0.5 ether); // each play is 0.5 ether

        /**
        this.balance assumes that no ethers was present however, an attaker can use self-destruct to
        send 0.1 ether to this contract and this.balance will never be a multiple or 0.5 eth, which 
        prevents all players from ever reaching a mulestone. 
         */
        // uint currentBalance = this.balance + msg.value;

        // replace this.balance
        uint currentBalance = depositedWei + msg.value;

        // ensure no players after the game has finished
        require(currentBalance <= finalMileStone);
        
        // if at a milestone, credit the player's account
        // with present ether, the following condistions will never be true and player will never reach
        // a milestone. 
        if (currentBalance == payoutMileStone1) {
            redeemableEther[msg.sender] += mileStone1Reward;
        }
        else if (currentBalance == payoutMileStone2) {
            redeemableEther[msg.sender] += mileStone2Reward;
        }
        else if (currentBalance == finalMileStone ) {
            redeemableEther[msg.sender] += finalReward;
        }

        // fix present ether
        depositedWei += msg.value;

        return;
    }

    function claimReward() public {
        // ensure the game is complete
        require(this.balance == finalMileStone);
        // ensure there is a reward to give
        require(redeemableEther[msg.sender] > 0);
        redeemableEther[msg.sender] = 0;
        msg.sender.transfer(transferValue);
    }
 }