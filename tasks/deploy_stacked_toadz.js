const fs = require('fs');
const deployments = require('../data/deployments');

task('deploy-stacked-toadz').setAction(async function () {
  const [deployer] = await ethers.getSigners();

  const name = "UnStackedToadz";
  const symbol = "USTACK"
  const baseURI = "ipfs://"

  const factory = await ethers.getContractFactory('StackedToadz', deployer);

  const instance = await factory.deploy(
    name,
    symbol,
    baseURI,
  );

  await instance.deployed();

  console.log(`Deployed Stacked Toadz Rink to: ${instance.address}`);
  deployments.stackedToadzRink = instance.address;

  const json = JSON.stringify(deployments, null, 2);
  fs.writeFileSync(`${__dirname}/../data/deployments.json`, `${json}\n`, {
    flag: 'w',
  });
});
