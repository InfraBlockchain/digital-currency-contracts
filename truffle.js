module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*"
        },
        ganache: {
          host: "localhost",
          port: 7545,
          network_id: "5777"
        },
        ropsten: {
            network_id: 3, // ropsten testnet
            host: "localhost",
            port: 8546,
            gas: 4712384,
            gasPrice: 90000000000000
        },
        rinkeby: {
            network_id: 4, // rinkeby testnet
            host: "localhost",
            port: 8547,
            gas: 4500000
        },
        live: {
            network_id: 1,
            host: "localhost",
            port: 8548,
            gas: 4712384
        }
    },
    migrations_directory: './migrations'
}
