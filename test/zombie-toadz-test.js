const { expect } = require('chai');
//import way to deal with bigNumber
var chai = require('chai');
const BN = require('bn.js');
const { ethers } = require("hardhat"); 
chai.use(require('chai-bn')(BN));
const deployments = require('../data/deployments');

/*  write it test functions for these solidity functions:
        function startLotto() public onlyOwner returns (bool)
        function buyTickets(uint256 _qty, uint256 amount) public
        function draw() public onlyOwner returns(address)
        function endLotto() public onlyOwner returns(address)
        function withdrawTokens() 
*/

describe('ZombieToadzContract Unit Test', function () {
    let accounts, contractOwner, defaultErc20, zombieToadzContract;
    before(async function () {
        accounts = await ethers.getSigners(); 
        contractOwner = accounts[0];
        let defaultErc20 = await ethers.getContractFactory('DefaultErc20', contractOwner);
        defaultErc20 = await defaultErc20.deploy();
        await defaultErc20.deployed();
        let ZombieToadzContract = await ethers.getContractFactory('ZombieToadz', contractOwner);
        zombieToadzContract = await ZombieToadzContract.deploy(deployments.DefaultErc20);
        await zombieToadzContract.deployed();
    });

    beforeEach(async function () {
        let mint = await defaultErc20.connect(contractOwner).mint(contractOwner, ethers.utils.parseUnits("10000000000", 18));
        await mint.wait();
    });
    //check if contract is strted 
    it(' ZombieToadzContract started succesffully ', async function () {
        expect((await zombieToadzContract.callStatic.setStarted()).toString()).to.equal('false');
    });
    //checkTotalSupply
    it(' checkTotalSupply', async function () {
        expect((await defaultErc20.callStatic.totalSupply()).toString()).to.equal('5555');
        console.log(await defaultErc20.callStatic.totalSupply());
    });
  /*  //check if price is changed
    it(' checkPrice', async function () {
        expect((await zombieToadzContract.callStatic.price()).toString()).to.equal('1');
    })*/


    //check if contract is ended


});
