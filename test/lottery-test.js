const { expect } = require('chai');

var chai = require('chai');
const BN = require('bn.js');
chai.use(require('chai-bn')(BN));

describe('LotteryContract Unit Test', function () {
    let accounts, contractOwner, lotteryContract, MAX_TICKETS = 999, PRICE = 5000000000000000000, QUANTITY = 1, AMOUNT = 1;
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
        expect((await lotteryContract.connect(contractOwner).startLotto()).toString()).to.equal('true');
    });
    it('Bought tickets in the lottery ', async function () {
        expect((await lotteryContract.connect(contractOwner).buyTickets(QUANTITY, AMOUNT)).toString()).to.equal('true');
    });
    /* it('Draw from lottery', async function () {
        await lotteryContract.callStatic.draw();
    });
    it('End lottery', async function () {
        await lotteryContract.callStatic.endLotto();
    });
    it('Withdraw tokens', async function () {
        await lotteryContract.callStatic.withdrawTokens();
    });*/

});
      //run the buyTickets function with the contract.connect(sender).${method_name} syntax
/*  write it test functions for these solidity functions:
        function startLotto() public onlyOwner returns (bool)
        function buyTickets(uint256 _qty, uint256 amount) public
        function draw() public onlyOwner returns(address)
        function endLotto() public onlyOwner returns(address)
        function withdrawTokens() 
*/