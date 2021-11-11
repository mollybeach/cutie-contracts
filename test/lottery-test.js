const { expect } = require('chai');

var chai = require('chai');
const BN = require('bn.js');
chai.use(require('chai-bn')(BN));

describe('LotteryContract Unit Test', function () {
    let accounts, contractOwner, lotteryContract, MAX_TICKETS = 999, PRICE = 5000000000000000000;
    before(async function () {
        accounts = await ethers.getSigners();
        contractOwner = accounts[0];
        LotteryContract = await ethers.getContractFactory('Lottery', contractOwner);
        lotteryContract = await LotteryContract.deploy(contractOwner.address);
        await lotteryContract.deployed();
    });

    beforeEach(async function () {
        await lotteryContract.setNumber(0);
    });

    it('Initial value is set to 0', async function () {
        expect((await lotteryContract.getNumber()).toString()).to.equal('0');
    });
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

