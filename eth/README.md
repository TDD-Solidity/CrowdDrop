# CrowdDrop
A simple airdrop smart contract

<br/>
<br/>


## Inheritance
<br/>

The inheritance structure is, admittedly, kind of confusing. 

The structure is inspired by the [CryptoKitties source code](https://ethfiddle.com/09YbyJRfiI), and the inheritance is to me just a fancy way of importing functions and variables that you can read or write from other files...

Here is the full inheritance chain. It all starts with "ExecutivesAccessControl", and each contract below it inherits from the one above it.

<br/>
<br/>

##  ExecutiesAccessControl
    - sets up the "ceo, coo, and cfo" (the all-power contract admins) addresses and modifiers.

    ⬇️

<br/>

## CrowdDropBase
    - sets up the core struct for a "CrowdDropEvent" and mapping of events.

    ⬇️

<br/>

## RecipientsManager
    - holds recipients only modifiers and functions for recipients to call, such as "registerForEvent" and "claimWinnings"

    ⬇️

<br/>

## ContributorManager
    - holds contributor only modifier and a function for contributor to call, "contributeToPot"

    ⬇️

<br/>

## AdminsManager
    - functions for assigning admins (called by coo), and functions for admins to call: "add / remove contributor", "add / remove elgible recipients", "start / stop event", "end registration"...

    ⬇️

<br/>

## CrowdDropCore
    - The only contract meant to be called by the outside world (eg. a javascript frontend using web3). This contract inherits everything from the previous contracts and exposes a single function allowing the ceo to upgrade the contract. 


<br/>
<br/>
<br/>

## Dev Stuff

_Note: The following guides make heavy usage of [node](https://nodejs.org) (preferably v14) and [truffle](https://www.trufflesuite.com) so be sure to have them installed!


## Remix Usage Guide

Here's a short guide on how to deploy this contract and play with it on [remix](https://remix.ethereum.org)!

<br/>

### Step 1 - Create A Build From The Source Code.

cd into the "eth" folder of this repo.

Install dependencies fresh:
```
rm -rf node_modules & npm i
```

Then run:
```
truffle build
```


### Step 2 - Deploy To Your Desired Testnet


<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

_but wait, there's more..._
<br/>
Want to contribute or build on top of this project? Read on for the local development setup guide!
<br/>
<br/>
<br/>
<br/>
<br/>

## Local Dev Guide

Navigate into `eth` directory. 

Install dependecnies:
```
npm i
```