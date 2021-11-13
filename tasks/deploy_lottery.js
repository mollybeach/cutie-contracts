
const fs = require('fs');
const deployments = require('../data/deployments');
//import bigNumber 

task('deploy-lottery').setAction(async function () {
  const [deployer] = await ethers.getSigners();

  const stackAddress = deployments.DefaultErc20;

  const factory = await ethers.getContractFactory('Lottery', deployer);

  const instance = await factory.deploy(
    stackAddress
  );
  const MAX_TICKETS = ethers.BigNumber.from(1);
  const PRICE = ethers.utils.parseUnits("50",18);

  await instance.deployed();
  //run start lotto function
  const runStartLotto = await instance.connect(deployer).startLotto();
  await runStartLotto.wait();
  //run buyTickets function 
  for (i = 0; i < 1000; i++) {
    const purchase = await instance.connect(deployer).buyTickets(MAX_TICKETS, PRICE) ;
    await purchase.wait();
  }
  console.log(`Deployed Lottery to: ${instance.address}`);
  deployments.lottery = instance.address;

  const json = JSON.stringify(deployments, null, 2);
  fs.writeFileSync(`${__dirname}/../data/deployments.json`, `${json}\n`, {
    flag: 'w',
  });
});
