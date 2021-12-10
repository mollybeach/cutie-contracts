const fs = require('fs');
const deployments = require('../data/deployments');
/*  write it task functions for these solidity functions:

  function setStart(bool _start) public onlyOwner returns (bool)
  function mint(uint256 _qty)
  function devMint() public onlyOwner 
  function mintFree(uint256 _qty) public canMintFree(_qty)
  function mintPublic(uint256 _qty) public payable canMint(_qty)

*/

task('deploy-draca').setAction(async function () {


  const QTY = 1;

  const NAME = "Draca";
  const SYMBOL = "DRACA"
  const BASE_URI = "ipfs://QmQSYiRMmF7KzVCiAMetjuY1b9pJqCgjzeVsJmFSpiwkms/"
  const ADDRESS = deployments.draca;

  const [deployer] = await ethers.getSigners();
  const factory = await ethers.getContractFactory('Draca', deployer);
  const instance;

  const constructor = await factory.deploy( //must have the same amount of arguments as the contract constructor
    NAME,
    SYMBOL,
    BASE_URI,
    ADDRESS
  ); 
  
  //before deploy : 
  function beforeDeployment() {
    console.log("beforeDeployment......");
    instance = await factory.deploy(constructor);
  }
    //after deploy :
  function afterDeployment() {
    console.log("afterDeployment ......");
    instance = await ethers.getContractAt('Draca',deployments.Draca);
  }
  beforeDeployment();
  await instance.deployed();
  console.log('instance');
  /*//call the approval function from Erc20 openZeppelin contract
  const approval = await erc20.connect(deployer).approve(instance.address, ALLOWED);
  await approval.wait();
  console.log('approval');*/
  //run  set start Function 
  const setStart = await instance.callStatic.setStart(true);
  console.log(setStart.toString());


/*

//run TotalSupply function
const totalSupply = await instance.callStatic.totalSupply();
console.log(totalSupply.toString());

 //run MintFunction
  const runMint = await instance.connect(deployer).mint(QTY);
  await runMint.wait();

  //run devMintFunction
  const runDevMint = await instance.connect(deployer).devMint();
  await runDevMint.wait();

  //run mintFreeFunction
  const runMintFree = await instance.connect(deployer).mintFree(QTY);
  await runMintFree.wait();

  //run mintPublicFunction
  const runMintPublic = await instance.connect(deployer).mintPublic(QTY);
  await runMintPublic.wait();


  
  */

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

