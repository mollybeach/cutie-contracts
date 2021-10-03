const fs = require('fs');
const deployments = require('../data/deployments');

task('deploy-staked-stacked-toadz').setAction(async function () {
  const [deployer] = await ethers.getSigners();

  // approximately 6000 blocks per day
  const RATE = ethers.utils
    .parseUnits('50', 18)
    .div(ethers.BigNumber.from('6000'));

  const EXPIRATION = ethers.BigNumber.from('3600000');

  const factory = await ethers.getContractFactory('StackedStakedToadz', deployer);
  const instance = await factory.deploy(
    deployments.stackerMainnet,
    deployments.stakedToadzMainnet, 
    RATE,
    EXPIRATION,
  );
  await instance.deployed();

  console.log(`Deployed StakedToadz to: ${instance.address}`);
  deployments.stakedStackedToadzMainnet = instance.address;

  const json = JSON.stringify(deployments, null, 2);
  fs.writeFileSync(`${__dirname}/../data/deployments.json`, `${json}\n`, {
    flag: 'w',
  });
});
