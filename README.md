## B9Labs Academy

### Certified Ethereum Developer Course

#### Project 2: Remittance Contract

You will create a smart contract named Remittance whereby:

there are three people: Alice, Bob & Carol.
Alice wants to send funds to Bob, but she only has ether & Bob wants to be paid in local currency.
luckily, Carol runs an exchange shop that converts ether to local currency.
Therefore, to get the funds to Bob, Alice will allow the funds to be transferred through Carol's exchange shop. Carol will collect the ether from Alice and give the local currency to Bob.

The steps involved in the operation are as follows:

Alice creates a Remittance contract with Ether in it and a puzzle.
Alice sends a one-time-password to Bob; over SMS, say.
Alice sends another one-time-password to Carol; over email, say.
Bob treks to Carol's shop.
Bob gives Carol his one-time-password.
Carol submits both passwords to Alice's remittance contract.
Only when both passwords are correct, the contract yields the Ether to Carol.
Carol gives the local currency to Bob.
Bob leaves.
Alice is notified that the transaction went through.
Since they each have only half of the puzzle, Bob & Carol need to meet in person so they can supply both passwords to the contract. This is a security measure. It may help to understand this use-case as similar to a 2-factor authentication.

Stretch goals:

add a deadline, after which Alice can claim back the unchallenged Ether
add a limit to how far in the future the deadline can be
add a kill switch to the whole contract
plug a security hole (which one?) by changing one password to the recipient's address
make the contract a utility that can be used by David, Emma and anybody with an address
make you, the owner of the contract, take a cut of the Ethers smaller than what it would cost Alice to deploy the same contract herself


#### About
This repository is part of a course by B9Labs academy.

All Solidity contracts included are **for educational purposes only**. Please do not use these in real-world scenario's.

#### Reference

    https://academy.b9lab.com/courses/course-v1:B9lab+ETH-22+2018-03/courseware/7919cb1e36e941999dabb2b1281301a0/3281bf5446fd4ce79c83535f21561e9b/?child=first

#### TODO
- Feedback 1
- Unit Tests
- Event logging
