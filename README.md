# Ethereum basic things that I am doing/ learning/ exploring in this repo
- Exploring ethereum
- Learning how to use wallets
- Create transactions
- Run basic smart contracts

# Security concerns
- Always do small test transactions with new accounts
- Account creations may go wrong and it is better to lose small amounts first

# Types of accounts
- EOA, i.e. metamask - has private key, can initiate transactions
- Contracts - has smart contracts, no private key
- Transactions to this @ causes contract to run on EVM
    - Can call other contracts function as a reaction
    - Typical DApp programming pattern - contract A call contract B to maintain a shared state across users of contract A

# Configuration used
- Ganache private blockchain
- VSCode Remix Extension

# Smart contract
- for withdrawal, i.e. sending eth to sender in a faucet
- require(... <= ...)
- msg object can be accessed, This is the transaction that trigerred the contract
- https://docs.soliditylang.org/en/latest/units-and-global-variables.html#block-and-transaction-properties
- created by special transactions that submit their bytecide to be recorded on the blockchain
- Is a special type of wallet, no private address thus cant initiate transactions
- Using Remix IDE, when u use the withdraw function, Metamask will construct the transaction to call the withdraw function from the contract

# Ethereum protocols
- Parity, written in Rust*
- Geth, written in Go*
- cpp-ethereum, written in C++
- pyethereum, written in Python
- Mantis, written in Scala
- Harmony, written in Java

# Development options
- No need run full mainnet node (hardware limitations)
- Can use testnet nodes, with a local private blockchain like ganache or cloud based (Infura)
- or remote clients

# Running Remote Clients (Wallets)
- Metamask
- Emerald Wallet
- MyEtherWallet
- MyCrypto
- web3.js
- ether.js

# Math and cryptography
- public key cryptography (public private key pair)
- private key controls access and is needed to create digital signatures
- elliptic curve cryptography
    - multiplication modulo a prime is simple but division (the inverse) is practically impossible
    - Used to combine message and private key
    - message can only be produces with knowledge of the private key
    - This is a digital signature
- A transaction is basically a request to access a particular account with a particular Ethereum address
- When sending transactions (interact with smart contract), you need to send it with a digital signature
- This digital signature has to be created with the private key corresponding to the Ethereum address in question

# More about key gens
- public key derived from private key
- verification of transactions no need private key knowledge
- private key needed to produce digital signature for transactions
- private key (78 digit no.) is made up of 256 random bits (64 hex) (pick a no. between 1 and 2**256)
- normally to produce private keys, feed large string of bits to 256 hash algo, this produces a 256-bit no. then check if the number is within range, if not try again
- generate public key by using ellptic curve multiplication
```
K = k * G
k is private key
G is constant point called the generator point
K is the resulting public key
* is an elliptic multiplication

# Example
generator point (G) is specifiied as part of the secp256k1 standard. 
then add generator point G k amount of times, G+G+G+...+G
use a cyptographic library (OpenSSL or libsecp256k1) to do the elliptic multiplication
resulting public key is defined as an x, y coordinate
the to get public key (all in hex, coords must be 64 hex long):
04 + x-coordinate (32 bytes/ 64 hex) + y-coordinate (32 bytes/ 64 hex)

```
# Hash functions
- SHA-3 mentioned in ETH documents is not the FIPS-202 SHA-3 due to controversies. It is the original Keccak-256 algorithm proposed by its inventors
- You can test which SHA-3 your library is using by hashing an empty string
```
Keccak256("") =
  c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470

SHA3("") =
  a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a
```

# Generate public addressess
- the generated K (public key) from elliptic multiplication
- Keccak256(K)
- Take 20 bytes/ 40 hex least significant bits (left most) as the address

# Wallets
- Controls access to user's money, managing keys and addressess, tracking balance and creating/ signing transactions
- No real distinctions in what makes up a wallet, but in the book it looks at is as private keys and as systems for managing these keys
- They only hold keys, the real money is actually stored on the blockchain

# Wallet Design
- Balanced convinience and privacy
- Users control tokens by signing transactions with keys stored in wallet

## Nondeterministic Wallets
- JBOK: just a bunch of keys
- Each key generated from different rand num and are not related to each other

### Properties
- replace old style wallets that stores single randomly generated private key
- practices new address (new private key) everytime you receive funds
- can also use new address for each transaction
- need regular backup cause may lose data to disk failure etc
- "type 0" is the hardest to deal with as they create a new wallet file for every new address in a "just in time" manner
- many eth clients use key store file, JSON-encoded that contains a single private key, encrypted by the passphrase for extra security
- uses password stretching to protect against brute-force, dictionary, and rainbow table attacks

## Deterministic wallet
- All keys derived from 1 single master key (seed)
- Can generate all keys again if you have the original seed
- Most common key derivation method: tree-like structure, Hierarchical Deterministic Wallets (BIP-32/BIP-44)
- To secure against data-loss, the original seeds are encoded as a list of words (can be any language) this the the mneumonic code words
- Your mneumonic can essentially recreate your whole wallet and gain access to your ether and smart contracts
- only need to backup once cause u only need original seed
- maximise security on 1 data may be seen as an advantage

### Hierarchical Deterministic Wallets (BIP-32/BIP-44)
- developed to easily derive many keys from seed
- so, seed produce master key
- master key produce hierarchy of keys, child->grandchild

#### Advantges
- tree structure
- specific branch of subkey can be used to receive incoming payment
- different branch can be used to receive change from outgoing payments
- branches can be used in corporate settings
- can create sequence of public keys without having access to corresponding private keys, thus, HD wallets can be used on an insecure server or watch-only or receive-only capacity where wallet has no private key to spend the funds

## Wallet best practices
- mneuomonic code words based on bip39
- HD wallets based on BIP32
- Multipurpose HD wallet structure based on bip43
- multicurrency and multiaccount wallets based on bip44

### Hardened derivation
- breaking the relationship between parent public key and chain code
- instead of using parent public key to derive chain code, use parent private key
- this new chain code cannot be used to copromise a parent or sibling private key
- have level1 children of the master keys always derived by hardened derivation

# Transactions
- signed messages produced by eos (private key wallets)
- transmitted by eth network
- recorded on eth blockchain
- the only thing that can cause a contract to execute in evm
- the only thing that can cause a change of state|
- Serialized, each client and application will store this serialized transaction in-memory using their own data structure
- serialization is extremely important in distributed systems,
- serialization is done by using *recursive length prefix* algorithm 
```
Serialization example
You have an array, want to store in DB but DB dun support array
you either take each element and store in db field, this assumes elements are not arrays themselves 
OR
you serialize it into a single string or string of bytes etc and store it
then when retrieving, unserialize it and you will have the original data
```

## Structure of transaction
- Nonce
- Gas price
- Gas limit
- Recipient
- Value
- Data
- v,r,s

# ABI
- you can generate ABI using solc in cmd line
``` $ solc --abi Faucet.sol ```
- This produces a JSON object
- JSON object can be used by any application that wants to access the Faucet contract once it is deployed
- application includes wallet or DApp browser can construct transactions that call faucet functions
- all the applciation needs is the address where the contract has been deployed and the ABI (JSON)

# delegate calls and library calls
- when you call a library, the call is always a delegate call
- it runs within the context of the caller
- so when library code is running, it inherits the context of the caller which would be the contract address
- This checksout and is the same as delegate call
- (DEPRECATED .call)
- for call functions, it does not inherit the context and thus the code will be called from the contract containing the code address, rather then the delegate call where it inherits the context and the code will be called from the contract calling the delegatecall function
```
i.e. contract A, B, C
C is caller,
A is normal contract that will be called
B is library

in C, C calls A.callFunctionName -> the function in A will be runed and called in A, e.g. calling 'this' will return A's address
in C, C calls B.callFunctionName -> the function in B will be runed and called in C, e.g. calling 'this' will return C's address
in C, C calls A.call (this .call is deprecates) -> the function in A will be runed and called in A, e.g. calling 'this' will return A's address
in C, C calls A.delegatecall -> the function in A will be runed and called in C, e.g. calling 'this' will return C's address
```

# gas
- extremely important consideration
- each function call uses gas
- need to balance between amount of gas used
- if gas limit is exceeded during computation due to too many function calls or chained contract calls or whatever other reason,
  - "out of gas" exception thrown
  - state of contract is restored (reverted)
  - All ether used to pay gas is taken as transaction fee and not refunded

# It is us as developer's interest to reduce gas costs so that users will not feel discouraged from calling functions. SO HOW?
- Avoid dynamically sized arrays
- Avoid calls to other contracts
- you can use functions to estimate gas cost, look up the web3 libraries
- Make it a habit to evaluate gas cost of functions as part of your development workflow

# Common contract vulnerabilities
## Suicidal contracts
Smart contracts that can be killed be arbitrary addresses
## Greedy contracts
Smart contracts that can reach a state in which they cannot release ether
## Prodigal contracts
Smart contracts that can be made to release ether to arbitrary addresses

# Safe practices
- use explicit type casting rather then implicit, see vyper's implementation
- issue: 
```
uint32 a = 0x12345678;
uint16 b = uint16(a);
// Variable b is 0x5678 now
```
- don't use modifiers, just do the assertions inline and in function
- this is dangerous as, if there are function calls in modifiers that cause a state of change in the smart contracts, it will be confusing for the developers to kee ptrack of and may incur vulnerabilities
- function overloading, use cautiously 
- avoid multiple inheritance
- Overflow errors
- always log, write to ethereum's chain data through log events so that the logs can be discovered and read on the public chain by light clients

# Preconditions and post conditions
## Condition
What is the current state/ condition of the ethereum state varibles
## Effects
What are the smart contract's intentions on its state variables, what will be affected. Are the 
## Interaction
After exhaustively dealing with the first 2 considerations, before deploying, logically step through the code and think of all possible permenatn outcomes, consequences and scenarios of executing the code, including interaction with other contracts. Document each of these points thoroughly

# Security Best Practices
Defensive programming
## Minimalism/ simplicity
Simpler code, the less it does, the lower the chances of unforeseen effects. Always find ways to o less with fewer lines of code and fewer features while still maintaining readability. 
## Code reuse
If a library or contract already exists that does most of what you need, reuse it. DRY principle
### Don't Repeat yourself
- If many smae code, can function? can use library?
- Dont try to improve a feature or component by building it from scratch
## Code quality
Always apply rigorous engineering and software deelopment methodologies. Always follow unforgiving discipline. Once your code is launched, ther is little you can do to fix it.
## Readability/ auditability
Clear and easy to comprehend. Easier to read == easier to audit. Anyone can read byte code as it is on the lbockchain and anyone can reverse engineer it. 
## Test coverage
Test everything you can. Test all arguments, and ensure that they are within expected ranges.

# Common Security Risks
Here we look at different common security risks in smart contracts and solutions that can address them

## Reentrancy
Contracts can call and utilize code from other external contracts. When sending ether to external users, contracts are required to submit external calls. These calls can be hijacked by attackers. This cause contracts to execute further code through a fallback function, including callbacks to themeselves.
Malicious code is found in the fallback function of the AttackContract when it receives ether from
the contract it is attacking. 
### Prevention
- Use built in transfer when sending ether to external contracts, this only sends the 2300 gas with the external contract which will not be enough for the destination address to call another contract
- Ensure that all logic and state change variable happens before ether is set out of contract (aka checks-effects-interactions pattern)
- introduce a mutex, this is a state variable that locks the contract during code execution
- See HoneyPot.sol and HoneyPotCollect.sol

## Arithmetic Over/Underflows
- EVM has fixed-size data types for int, i.e. uint8 uint16 uint32...
- trying to store decimal 256 in uint8 will result in 0 as 256 is 0x0100, uint8 takes lower order hex and 8 bits only so 2 hexes which will be 0x00 thus decimal of 0
- similarly, decrementing a 0x00 for uint8 by 0x01 will result in 0xFF, the maximum possible value
- use safe math library by open zepplin, see TimeLock.sol
### Prevention
- use open zepplin's safe math library arithmetics

## Unexpected Ether
- Contracts can receive funds regardless of if the function is payable or not
- incorrect use of `this.balance` has a rnge of vulnerabilities
- this leads to contract having false assumptions about the ether balance within them
### Self-destruct function
- This function can send ether to the address specified in the parameter when destroying a contract
- The sending of ether to another contract normally invokes the fallback function of the receiving contract, however with this function will not invoke any functions including fallback function and can forcibly send ether to any contract.
### Pre-sent ether
- another way to force ether into contract without payable
- sending ether to the address of the contract before the contract is created. This will cause the contract when created to have a nonzero ether balance.
### Prevention
- most of these vulns arises from the `this.balance`
- avoid being dependent on this.balance
- use a self defined variable, this variable will also not be affected by seldestruct calls
- this is a defensive programming technique called invariant checking

## Delegatecall

