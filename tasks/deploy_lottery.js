const fs = require('fs');
const deployments = require('../data/deployments');

task('deploy-lottery').setAction(async function () {
  const [deployer] = await ethers.getSigners();

  const stackAddress = deployments.DefaultErc20

  const factory = await ethers.getContractFactory('Lottery', deployer);

  const instance = await factory.deploy(
    stackAddress
  );

  await instance.deployed();

  console.log(`Deployed Lottery to: ${instance.address}`);
  deployments.lottery = instance.address;

  const json = JSON.stringify(deployments, null, 2);
  fs.writeFileSync(`${__dirname}/../data/deployments.json`, `${json}\n`, {
    flag: 'w',
  });
});
