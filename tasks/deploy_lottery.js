const fs = require('fs');
const deployments = require('../data/deployments');

task('deploy-lottery').setAction(async function () {
  const [deployer] = await ethers.getSigners();

  const stackAddress = deployments.DefaultErc20;

  const factory = await ethers.getContractFactory('Lottery', deployer);

  const instance = await factory.deploy(
    stackAddress
  );
  const MAX_TICKETS = 999;
  
  await instance.deployed();
  //buyTickets
  for (i = 0; i < 1000; i++) {
    const purchase = await instance.connect(sender).buyTickets(MAX_TICKETS, instance.balanceOf(sender.address)) ;
    await purchase.wait();
  }
  console.log(`Deployed Lottery to: ${instance.address}`);
  deployments.lottery = instance.address;

  const json = JSON.stringify(deployments, null, 2);
  fs.writeFileSync(`${__dirname}/../data/deployments.json`, `${json}\n`, {
    flag: 'w',
  });
});
