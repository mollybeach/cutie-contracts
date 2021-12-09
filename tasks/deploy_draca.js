const fs = require('fs');
const deployments = require('../data/deployments');
/*  write it task functions for these solidity functions:

  function setStart(bool _start) public onlyOwner returns (bool)
  function tokensOfOwner(address owner)
  function mintDev(uint256 _times, uint256 _tokenId) payable public 
  function mintFree(uint256 _times, uint256 _tokenId) payable public 
  function mintPublic(uint256 _times) payable public

*/
task('deploy-draca').setAction(async function () {

  const TOKEN_ID = 0000;
  const PRICE = ethers.utils.parseUnits("20",18);
  const TIMES = 1;
  const ALLOWED = ethers.utils.parseUnits("100000000000000",18);
  const NAME = "Draca";
  const SYMBOL = "DRACA"


  const [deployer] = await ethers.getSigners();
  const STACK_ADDRESS = deployments.DefaultErc20;
  const erc20 = await ethers.getContractAt('DefaultErc20', deployments.DefaultErc20);
  const factory = await ethers.getContractFactory('Draca', deployer);
  console.log('factory');
  //before deploy : 
  const instance = await factory.deploy( //must have the same amount of arguments as the contract constructor
    NAME,
    SYMBOL,
    STACK_ADDRESS,
  ); 
  //after deploy :
  //const instance = await ethers.getContractAt('Draca',deployments.Draca);

  await instance.deployed();
  console.log('instance');
  //call the approval function from Erc20 openZeppelin contract
  const approval = await erc20.connect(deployer).approve(instance.address, ALLOWED);
  await approval.wait();
  console.log('approval');
  //run  set start Function 
  const setStart = await instance.callStatic.setStart(true);
  console.log(setStart.toString());

    //run TokensOfOwner Function after deploy
    /*const runTokensOfOwner = await instance.connect(deployer).tokensOfOwner(instance.address);
    await runTokensOfOwner.wait();
    tokensOfOwner*/

  //before deploy
    const runTokensOfOwner = await instance.callStatic.tokensOfOwner(instance.address);
    console.log(runTokensOfOwner.toString());
/*
  //run MintFree Function
  const runMintFree = await instance.connect(deployer).mintFree(TOKEN_ID, TIMES);
  await runMintFree.wait();

  //run MintDev Function
  const runMintDev = await instance.connect(deployer).mintFree( TIMES);
  await runMintDev.wait();

  //run MintPublic Function
  const runMintPublic = await instance.connect(deployer).mintFree(TIMES);
  await runMintPublic.wait();

  console.log(`Deployed Draca to: ${instance.address}`);
  deployments.Draca = instance.address;
  
  //write Draca to deployments json file 
  const json = JSON.stringify(deployments, null, 2);
  fs.writeFileSync(`${__dirname}/../data/deployments.json`, `${json}\n`, {
    flag: 'w',
  });
  console.log(json);
  */
});
//yarn run hardhat deploy-draca --network localhost

