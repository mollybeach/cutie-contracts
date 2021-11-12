
const { expect } = require('chai');
//import way to deal with bigNumber

var chai = require('chai');
const BN = require('bn.js');
chai.use(require('chai-bn')(BN));

/*  write it test functions for these solidity functions:
        function startLotto() public onlyOwner returns (bool)
        function buyTickets(uint256 _qty, uint256 amount) public
        function draw() public onlyOwner returns(address)
        function endLotto() public onlyOwner returns(address)
        function withdrawTokens() 
*/

describe('LotteryContract Unit Test', function () {
    let accounts, contractOwner, lotteryContract, MAX_TICKETS = 999, PRICE = 50, QUANTITY = 1, AMOUNT = 60;
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
        await lotteryContract.connect(contractOwner).startLotto();
    });
    it('Bought tickets in the lottery ', async function () {
        await lotteryContract.connect(contractOwner).buyTickets(QUANTITY, AMOUNT);
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
/* Issues :
ATTEMPT: LotteryContract as is 
        FAIL -----> ERROR :  * Error: Big number problem with 18 digits.  * 
ATTEMPT: temporarily change from PRICE = 5000000000000000000; to PRICE = 50 and AMOUNT = 6000000000000000000 to AMOUNT = 60; to continue testing , 
        FAIL -----> ERROR :  * Transaction reverted without a reason string *
ATTEMPT: comment out lines in buyTicket function() to find error 
            line 1  : require(LOTTO_LIVE);
        PASS
            line 2  : require(amount >= PRICE * _qty);
        PASS
            line 3  : require(_qty > 0);
        PASS
            line 4  : require(amount >= PRICE * _qty);
        PASS
            line 5 : require(TICKETBAG.length + _qty <= MAX_TICKETS);
        PASS
            line 6 : require(IERC20(stackAddress).transferFrom(_msgSender(), address(this), PRICE * _qty));
        FAIL -----> ERROR :  *  Error: Transaction reverted: function call to a non-contract account *
ATTEMPT: comment out line 6 and remaining lines in buyTicket function to find error 
            line 7 : for (uint256 i = 0; i < _qty; i++) {
                        TICKETBAG.push(msg.sender);
                    }
        PASS
            line 8  : emit JoinEvent (TICKETBAG.length, _qty);
        PASS
            line 9 :  if(TICKETBAG.length == MAX_TICKETS) {
                        endLotto();
                    }
        PASS
*/