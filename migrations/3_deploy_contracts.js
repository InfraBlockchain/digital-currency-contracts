var SnapshotableTokenFactoryContract = artifacts.require("SnapshotableTokenFactory");
var DKRWTokenContract = artifacts.require("DKRWToken");

module.exports = function(deployer, network, accounts) {

    var contractOwner = '0xc0c579bf205334775a83bb1f6e3b910ac07993fd';
    var snapshotableTokenFactory;
    var dKRWToken;

    console.log(network);
    // console.log(accounts);

    if (network == 'develop') {

        snapshotableTokenFactory = {
            address : '0xa8e055d89579a74b0110728a740e18e80c44e211'
        };

        dKRWToken = {
            address : '0xaeee4b4fdfa06dc8f259b46019a1cdc7fd631001',
            initialOwner : '0x5677e23889387f0d0e774f2e930e91bcee9dcaa6',
            initialSupply : web3.toWei('100000000','ether')
        };

    } else if (network == "ropsten") { // ropsten testnet
        throw "error: deployment for ropsten network is not yet supported";

    } else if (network == "rinkeby") { // rinkeby testnet

        snapshotableTokenFactory = {
            address : '0x188e2f719f49a9bbcb20ac4f872494848d1a04d4'
        };

        dKRWToken = {
            address : '0xc46550c3679240ab3bbc7e8b49b6c6b9e396c544',
            initialOwner : '0x5ba118686ce27c59d695833661268697d4ce0523',
            initialSupply : web3.toWei('100000000','ether')
        };


    } else if (network == "live") {
        throw "error: deployment for live network is not yet supported";
    }

    console.log('Starting Contract Deployment on network ' + network);
    console.log(snapshotableTokenFactory);
    console.log(dKRWToken);

    var tfPromise = SnapshotableTokenFactoryContract.at(snapshotableTokenFactory.address).then(function (exiTF) {
        console.log('Found existing SnapshotableTokenFactory contract at ' + exiTF.address);
        return Promise.resolve(exiTF);
    }).catch(function (err) {
        if (err.message && err.message.includes('Cannot create instance of')) {
            console.log('Deploying new SnapshotableTokenFactory contract');
            return SnapshotableTokenFactoryContract.new({from: contractOwner}).then(function (newTF) {
                console.log('Deployed new SnapshotableTokenFactory contract at ' + newTF.address);
                return newTF;
            }).catch(function (err) {
                console.log(err)
            });
        } else {
            console.error(err);
            return Promise.resolve(null);
        }
    });

    tfPromise.then(function (tf) {
        console.log('SnapshotableTokenFactory contract at ' + tf.address);

        DKRWTokenContract.at(dKRWToken.address).then(function (exiT) {
            console.log('Found existing DKRWToken contract at ' + exiT.address);
            return Promise.resolve(exiT);
        }).catch(function (err) {
            if (err.message && err.message.includes('Cannot create instance of')) {
                console.log('Deploying new DKRWToken contract');
                return DKRWTokenContract.new(tf.address,{from: contractOwner}).then(function (newT) {
                    console.log('Deployed new DKRWToken contract at ' + newT.address);
                    console.log('Sending Transaction : DKRWToken.generateTokens() for initial supply');
                    return newT.generateTokens(dKRWToken.initialOwner, dKRWToken.initialSupply, {from: contractOwner}).then(function (resGenTokens) {

                        if (resGenTokens.logs && resGenTokens.logs.length > 0 && resGenTokens.logs[0].event == 'Transfer') {
                            console.log('DKRWToken.generateTokens() Success!');
                            console.log(resGenTokens.logs);
                            return newT;
                        } else {
                            console.log(resGenTokens);
                            return null;
                        }
                    });
                });
            } else {
                console.error(err);
                return Promise.resolve(null);
            }
        });
    });
};
