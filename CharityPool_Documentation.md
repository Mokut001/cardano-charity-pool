Charity Pool DApp — Documentation
1. Introduction
The Charity Pool DApp is a simple and transparent decentralized application built on the Cardano blockchain using Plutus (Haskell) for the smart contract and Lucid + CIP-30 for the frontend wallet interaction.
The purpose of this project is to solve a real-life problem:
Real-Life Problem
Traditional charity systems lack:
Transparency
Trust
Public visibility of funds
Assurance that money reaches the right parties
Proposed Solution
A decentralized smart contract that:
Receives donations in ADA
Stores them securely at a script address
Allows only the charity owner to withdraw funds
Ensures full transparency because:
Every donation is recorded on-chain
Every withdrawal is visible to the public
This serves as a real-world DeFi charity escrow system—excluding intermediaries and preventing mismanagement.
2. Overall Architecture
Main Components
Smart Contract (Haskell / Plutus)
Located in: contract/CharityPool.hs
Defines:
Who can withdraw funds
How donations are locked
How validator checks signatures
Frontend (Lucid + HTML + JS)
Located in: frontend/
Files:
CharityFrontend.hs
wallet.js
style.css
Wallet Integration
Using CIP-30 standard
Wallet supported: cbyox (plus any CIP-30 compatible wallet)
Script Address
The compiled Plutus validator produces a script address
Users can deposit ADA here directly
3. Smart Contract Design
3.1 Contract Logic
The smart contract uses:
Datum: Doesn’t store data (simple empty datum)
Redeemer: Only one action → Withdraw
Validator:
Accepts any deposit transaction
Accepts withdraw only if signed by the owner
3.2 Security Guarantee
Donations cannot be stolen
Funds cannot be moved without owner’s signature
No backdoor, no administrator override
3.3 File Contents
Validator
The validator checks:
Copy code
Haskell
txSignedBy info owner
Where owner is a PubKeyHash you will replace.
Script Address
Generated from:
Copy code
Haskell
scriptAddress validator
Users deposit ADA to this address.
4. Frontend Architecture
4.1 Lucid (Haskell) HTML Generator
CharityFrontend.hs generates a simple functional webpage:
Connect Wallet
Deposit ADA
Withdraw (owner only)
Display status and TxHash
4.2 CIP-30 (wallet.js)
Functions included:
connectWallet()
deposit()
withdraw()
Each action uses:
Copy code
Javascript
walletApi.buildTransaction()
walletApi.signTx()
walletApi.submitTx()
And interacts with the scriptAddress.
5. User Flow
5.1 Donor Workflow
Open the deployed DApp
Connect wallet
Enter ADA amount
Click “Deposit”
Funds are locked in the contract
5.2 Owner Workflow
Connect wallet with owner’s Pkh
Click “Withdraw”
Contract validates owner signature
Funds sent to owner
