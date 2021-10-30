const deployments = require('../data/deployments');

task('set-fish-rewards')
  .setAction(async function () {
    const [sender] = await ethers.getSigners();

    const instance = await ethers.getContractAt(
      'FishStaking',
      deployments.fishFixedMain,
    );

    const rateUnstack = ethers.utils
      .parseUnits('10',18)
      .div(ethers.BigNumber.from('6000'));

    const expirationUnstack = ethers.BigNumber.from('360000');

    const setUnstackDuration = await instance 
      .connect(sender)
      .setExpiration(expirationUnstack);
    await setUnstackDuration.wait();

    const setUnstackRate = await instance
      .connect(sender)
      .setRate(rateUnstack);
    await setUnstackRate.wait();

    const unpauseUnstack = await instance
      .connect(sender)
      .unpause();
    await unpauseUnstack.wait();
});
