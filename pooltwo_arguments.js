const fs = require('fs');
const deployments = require('./data/deployments');

module.exports = [
    deployments.stakedToadzMainnet,
    deployments.stackv2LpTokenMainnet
]