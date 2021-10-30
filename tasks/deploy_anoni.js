const fs = require('fs');
const deployments = require('../data/deployments');

task('deploy-anoni').setAction(async function () {
  const [deployer] = await ethers.getSigners();

  const name = "An0n1-Punks";
  const symbol = "AN0N1PUNK"
  const baseURI = "ipfs://QmQSYiRMmF7KzVCiAMetjuY1b9pJqCgjzeVsJmFSpiwkms/"

  const factory = await ethers.getContractFactory('AnoniPunk', deployer);

  const instance = await factory.deploy(
    name,
    symbol,
    baseURI,
  );

  await instance.deployed();

  console.log(`Deployed Stacked Toadz Rink to: ${instance.address}`);
  deployments.anoniPunk = instance.address;

  const json = JSON.stringify(deployments, null, 2);
  fs.writeFileSync(`${__dirname}/../data/deployments.json`, `${json}\n`, {
    flag: 'w',
  });
});
