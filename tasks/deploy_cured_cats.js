const fs = require('fs');
const deployments = require('../data/deployments');
/*  
write it task functions for these solidity functions:

    function setStart(bool _start) public onlyOwner returns (bool);
    function setStart() public onlyOwner
    function totalSupply() public view virtual override returns (uint256) 
    //function getLastBredCuredCat(uint256 tokenId) public view returns (uint256)
    function transformCuredCat(uint256[] calldata _tokenIds, uint256 amount) public {
*/

task('deploy-cured-cats').setAction(async function () {

    const QTY = 1;
    const [deployer] = await ethers.getSigners();
    const mutantAddress = `0xaAdBA140Ae5e4c8a9eF0Cc86EA3124b446e3E46A`
    const serumAddress = `0x1c579006cd499871ac39aa2bf787462de603936c`;

   /*************** before deployment : *************/
    
    const NAME = "CuredCats";
    const SYMBOL = "CuredCats"
    const BASE_URI = "ipfs://"
    console.log("beforeDeployment......");
    const factory = await ethers.getContractFactory('CuredCats', deployer);
    const instance = await factory.deploy(NAME, SYMBOL, BASE_URI, mutantAddress, serumAddress); //must have the same amount of arguments as the contract constructor
  /*************** after deployment : *************/
    
  //console.log("afterDeployment ......");
  //const instance = await ethers.getContractAt('CuredCats',deployments.CuredCats);

  /********call and await the instance to be deployed ********/
    await instance.deployed();

 /**************** test contract functions:  *************/
 //run  setStart Function 
    const runSetStart = await instance.callStatic.setStart();
    console.log(runSetStart.toString());
    console.log("setStart() passed successfully");

//run TotalSupply function
    const runTotalSupply = await instance.callStatic.totalSupply();
    console.log(runTotalSupply.toString());
    console.log("totalSupply() passed successfully");
    
//run MintFunction
  //  const runTransformCuredCat = await instance.connect(deployer).transformCuredCat(QTY);
   // await runTransformCuredCat.wait();
  //  const runTransformCuredCat = await instance.callStatic.transformCuredCat(QTY);
  //  console.log(runTransformCuredCat.toString());
  //  console.log("transformCuredCat() passed successfully");

//run withdrawCuredCats function
    const runWithdrawCuredCats = await instance.connect(deployer).withdrawCuredCats();
    await runWithdrawCuredCats.wait();

    console.log(`Deployed CuredCats to: ${instance.address}`);
    deployments.CuredCats = instance.address;
    //write CuredCats to deployments json file 
    const json = JSON.stringify(deployments, null, 2);
    fs.writeFileSync(`${__dirname}/../data/deployments.json`, `${json}\n`, {
        flag: 'w',
    });
    console.log(json);
});
//yarn run hardhat deploy-cured-cats --network localhost

