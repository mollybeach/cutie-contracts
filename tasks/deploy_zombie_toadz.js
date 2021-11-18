const fs = require('fs');
const deployments = require('../data/deployments');



/*  write it task  functions for these solidity functions:
        constructor(string memory name_, string memory symbol_, string memory baseURI_) ERC721(name_, symbol_); 
        function totalSupply() public view virtual returns (uint256)
        function changePrice(uint256 _newPrice) public onlyOwner
        function changeBatchSize(uint256 _newBatch) public onlyOwner
        function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
        function setTokenURI(uint256 _tokenId, string memory _tokenURI) public onlyOwner
        function setStart(bool _start) public onlyOwner
        function devMint(uint256 _times) public onlyOwner
        function mintToad(uint256 _times) payable public
*/
task('deploy-zombie-toadz').setAction(async function () {
    const NAME = 'ZombieToadz', SYMBOL = 'BRAINZ', BASE_URI = 'ipfs://QmWf3ywafrdzWx6QjUJiRe6NqMkb28rfPj3oBBkokTL199/';
    const [deployer] = await ethers.getSigners();
    console.log(deployer);
    const factory = await ethers.getContractFactory('ZombieToadz', deployer);
    //before deploy :
    const instance = await factory.deploy(
        NAME,
        SYMBOL,
        NAME

    );
    //after deploy : 
   // const instance = constructor;
  //const instance = await ethers.getContractAt('ZombieToadz',deployments.ZombieToadz);
    await instance.deployed();

    console.log(`Deployed ZombieZombieToadz to: ${instance.address}`);
    deployments.zombieToadzMainnet = instance.address;
    const json = JSON.stringify(deployments, null, 2);
    fs.writeFileSync(`${__dirname}/../data/deployments.json`, `${json}\n`, {
        flag: 'w',
    });
});

//yarn run hardhat deploy-zombie-toadz --network localhost

