const deployments = require('../data/deployments');

task('reward-params-fish')
  .addParam('duration')
  .setAction(async function ({ amount, duration }) {
    const [sender] = await ethers.getSigners();

    const instance = await ethers.getContractAt(
      'FishPoolTwo',
      deployments.fishRewardsMainnet,
    );

    // duration should be: 585000 blocks
    const tx = await instance
      .connect(sender)
      .setRewardParams(ethers.utils.parseUnits("90000", 18), duration);
    await tx.wait();
  });
