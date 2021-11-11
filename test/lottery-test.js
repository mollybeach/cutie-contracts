const { expect } = require("chai");
const { ethers, network } = require("hardhat");

describe("Lottery", function () {
    //this.timeout(100000);
    let accounts, contractOwner, lotteryContract, MAX_TICKETS = 999, PRICE = 5000000000000000000;
    before(async () => {
        console.log("before function running");
        accounts = await ethers.getSigners();
        contractOwner = accounts[0];
      //  console.log('Contract Owner: ' + accounts);
        const contractFactory = await ethers.getContractFactory("Lottery", contractOwner);
        lotteryContract = await contractFactory.deploy(
            contractOwner.address,
        );
        console.log("Lottery Contract" + lotteryContract);
        await lotteryContract.deployed();
        console.log('Lottery Contract: Deployed');
    });
    beforeEach(async function (){
        console.log('before each function running');
        await lotteryContract.callStatic.setNumber(0);
    })
    it('Intial value is set to 0'), async function () {
        console.log('it function running ')
        const number = await lotteryContract.callStatic.getNumber();
        console.log('number: ' + number);
        expect(number).to.equal(0);
    }
/* it('Lottery is not started'), async function () {
        const started = await lotteryContract.callStatic.checkStarted();
        expect(started).to.equal(false);
    }
    it('Check that tickets is equal to MAX_TICKETS') , async function () {
        const tickets = await lotteryContract.callStatic.getTickets();
        expect(tickets).to.equal(MAX_TICKETS);
    }
    it('Check that price is equal to PRICE') , async function () {
        const price = await lotteryContract.callStatic.getPrice(params);
        expect(price).to.equal(PRICE);
    }
           // await lotteryContract.setOwner(contractOwner.address);
    */

});

