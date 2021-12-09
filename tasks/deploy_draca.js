const fs = require('fs');
const deployments = require('../data/deployments');
//import bigNumber 
/*  write it task functions for these solidity functions:
  function setStart(bool _start) public onlyOwner returns (bool)
  function tokensOfOwner(address owner)
  function mintDev(uint256 _times, uint256 _tokenId) payable public 
  function mintFree(uint256 _times, uint256 _tokenId) payable public 
  function mintPublic(uint256 _times) payable public

*/
task('deploy-draca').setAction(async function () {
  const [deployer] = await ethers.getSigners();

  const stackAddress = deployments.DefaultErc20;
  const erc20 = await ethers.getContractAt('DefaultErc20', deployments.DefaultErc20);
  const factory = await ethers.getContractFactory('Draca', deployer);
  //before deploy : 
  const instance = await factory.deploy(stackAddress);
  //after deploy :
  //const instance = await ethers.getContractAt('Draca',deployments.Draca);

  const TOKEN_ID = 0000;
  const PRICE = ethers.utils.parseUnits("20",18);
  const TIMES = 1;
  const ALLOWED = ethers.utils.parseUnits("100000000000000",18);
  await instance.deployed();

  //call the approval function from Erc20 openZeppelin contract
  const approval = await erc20.connect(deployer).approve(instance.address, ALLOWED);
  await approval.wait();

  //run check started Function 
  const setStart = await instance.callStatic.checkStarted();
  console.log(setStart.toString());

  //run TokensOfOwner Function
  const runTokensOfOwner = await instance.connect(deployer).tokensOfOwner(instance.address);
  await runTokensOfOwner.wait();

  //run MintFree Function
  const runMintFree = await instance.connect(deployer).mintFree(TOKEN_ID, TIMES);
  await runMintFree.wait();

  //run MintDev Function
  const runMintDev = await instance.connect(deployer).mintFree(TOKEN_ID, TIMES);
  await runMintDev.wait();

  //run MintPublic Function
  const runMintPublic = await instance.connect(deployer).mintFree(TIMES);
  await runMintPublic.wait();

  //run withdrawTokens function
  const runWithdrawTokens = await instance.connect(deployer).withdrawTokens();
  await runWithdrawTokens.wait();

  console.log(`Deployed Draca to: ${instance.address}`);
  deployments.Draca = instance.address;
  
  //write Draca to deployments json file 
  const json = JSON.stringify(deployments, null, 2);
  fs.writeFileSync(`${__dirname}/../data/deployments.json`, `${json}\n`, {
    flag: 'w',
  });
  console.log(json);
});
//yarn run hardhat deploy-draca --network localhost

