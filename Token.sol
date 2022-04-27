pragma solidity ^0.6.4;

import "Faucet.sol";

contract Token is mortal {
	Faucet _faucet;

    // instantiate new contract
	constructor() {
		_faucet = new Faucet();
        //_faucet = (new Faucet).value(0.5 ether)();
	}

    /*
    // casting address of existing contract
    // risky, we are not sure if _f is infact a Faucet object
    constructor(address _f) {
		_faucet = Faucet(_f);
		_faucet.withdraw(0.1 ether)
	}
    */

    function destroy() ownerOnly {
		_faucet.destroy();
	}
}