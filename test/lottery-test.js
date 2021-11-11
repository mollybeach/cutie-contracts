const { expect } = require('chai');

var chai = require('chai');
const BN = require('bn.js');
chai.use(require('chai-bn')(BN));

describe('LotteryContract Unit Test', function () {
    let accounts, contractOwner, lotteryContract, MAX_TICKETS = 999, PRICE = 5000000000000000000;
    before(async function () {
        accounts = await ethers.getSigners();
        contractOwner = accounts[0];
        let LotteryContract = await ethers.getContractFactory('Lottery', contractOwner);
        lotteryContract = await LotteryContract.deploy(contractOwner.address);
        await lotteryContract.deployed();
    });

    beforeEach(async function () {
        await lotteryContract.callStatic.setNumber(0);
    });

    it('Lottery has not started ', async function () {
        expect((await lotteryContract.callStatic.checkNotStarted()).toString()).to.equal('false');
    });
    it('Price of entering lottery equals PRICE ', async function () {
        expect((await lotteryContract.callStatic.getPrice()).toString()).to.equal(PRICE.toString());
    });
    it('Maximum tickets equals MAX_TICKETS ', async function () {
        expect((await lotteryContract.callStatic.getMax()).toString()).to.equal(MAX_TICKETS.toString());
    });
    it('Lottery has started ', async function () {
        expect((await lotteryContract.callStatic.startLotto()).toString()).to.equal('true');
    });

/* 
    it('Check that price is equal to PRICE') , async function () {
        const price = await lotteryContract.callStatic.getPrice(params);
        expect(price).to.equal(PRICE);
    }
           // await lotteryContract.setOwner(contractOwner.address);
    */

});

