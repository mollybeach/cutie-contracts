const fs = require('fs');
const deployments = require('./data/deployments');

const RATE = ethers.utils
.parseUnits('10', 18)
.div(ethers.BigNumber.from('6000'));

const EXPIRATION = ethers.BigNumber.from('3600000');

module.exports = [
    deployments.stackedToadzRink,
    RATE,
    EXPIRATION,
]