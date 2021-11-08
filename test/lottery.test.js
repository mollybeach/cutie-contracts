const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("Our Lottery Contract", function () {

    let lottery;
    let owner;
    let addr1;
    let addr2;

    beforeEach(async function() {
        const Lottery = await hre.ethers.getContractFactory("Lottery");
        lottery = await Lottery.deploy();
        await lottery.deployed();

        [owner, addr1, addr2] = await ethers.getSigners();

    });
    it("Should should successfully deploy", async function () {
    console.log("success!");
    });

});
