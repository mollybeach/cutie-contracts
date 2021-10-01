const fs = require('fs');
const deployments = require('../data/deployments');

task('deploy-stacker').setAction(async function () {
  const [deployer] = await ethers.getSigners();

  const name = "StackedToadz";
  const symbol = "STACK"
  const baseURI = "ipfs://"

  const factory = await ethers.getContractFactory('Stacker', deployer);

  const instance = await factory.deploy(
    name,
    symbol,
    deployments.stackedToadzRink,
    baseURI,
  );

  await instance.deployed();

  console.log(`Deployed stackerRink to: ${instance.address}`);
  deployments.stackerRink = instance.address;

  const json = JSON.stringify(deployments, null, 2);
  fs.writeFileSync(`${__dirname}/../data/deployments.json`, `${json}\n`, {
    flag: 'w',
  });
});
