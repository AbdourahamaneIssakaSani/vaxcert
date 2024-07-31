
# VaccineCertificate

## Introduction

This repository contains a simple Smart Contract that can be used to issue, verify or revoke vaccine certificates.

## Deployed Contract

- <https://cardona-zkevm.polygonscan.com/address/0x1974d96a0dccd8882d70cc8616648876725a3eb8>

## Prerequisites

- Node.js
- npm
- Hardhat
- Remix IDE

## Setup

Clone the repository:

```sh
git clone git@github.com:AbdourahamaneIssakaSani/vaxcert.git
```

Go to the project directory

```sh
cd vaxcert
```

Install dependencies

```sh
npm install --legacy-peer-deps
```

## Software Testing

### Using Hardhat

We have written some test cases in javascript to make sure the contract behaves correctly once deployed.

From the root project of the app, create `.env` file and add the private key as follow:

```sh
PRIVATE_KEY=<YOUR_PRIVATE_KEY>
```

To compile, run

```sh
npx hardhat compile
```

then:

```sh
npm test
```

Expected Output:

```sh
vaxcert $ npm test

> vaxcert@1.0.0 test
> npx hardhat test



  VaccineCertificate
    ✔ Should set the right authority
    ✔ Should add and remove an authority
    ✔ Should issue a certificate
    ✔ Should revoke a certificate
    ✔ Should not revoke a certificate issued by another authority (74ms)
    ✔ Should verify a certificate
    ✔ Should get certificate details
    ✔ Should get the issuer of a certificate


  8 passing (2s)
```

The test cases inlcudes the deployement and tranfers between accounts, ensuring that all expectations are met.

### Smart Contract Deployment using Remix IDE

1. Open Remix IDE.
2. Create `VaccineCertficate.sol` and paste the Solidity code.
3. Compile and deploy the contract using MetaMask.
