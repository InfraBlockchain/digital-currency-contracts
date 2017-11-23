pragma solidity ^0.4.18;

/*
    Copyright 2017, Yosemite X Inc.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/// @title DKRWToken Contract
/// @author Bezalel Lim <bezalel@artstockx.com>

import "./SnapshotableToken.sol";

contract DKRWToken is SnapshotableToken {

    mapping (address => uint256) nonces;

    /// @notice DKRWToken constructor
    /// @param _tokenFactory The address of the SnapshotableTokenFactory contract that
    ///   will create the Clone token contracts, the token factory needs to be deployed first
    function DKRWToken(
        address _tokenFactory
    ) public SnapshotableToken(
        _tokenFactory,
        0x0,               // no parent token
        0,                 // no snapshot block number from parent
        "dKRW Test Token", // Token name
        18,                // Decimals
        "DKRW",            // Symbol
        true               // Enable transfers
    ) {}

    function transferDelegated(address _from, address _to, uint256 _value, bytes _data, uint256 _delegationFee, uint256 _nonce, bytes _signature) public returns (bool success) {

        uint256 nextNonce = nonces[_from] + 1;
        nonces[_from] = nextNonce;
        require(_nonce == nextNonce);

        bytes32 msgHash = keccak256(address(this), "transferDelegated", _from, _to, _value, _data, _delegationFee, _nonce);

        // Check the signature signed by '_from'
        assert(ecverify(msgHash, _signature, _from));

        transferFromTo(_from, _to, _value, _data);
        if (_delegationFee > 0) {
            transferFromTo(_from, msg.sender, _delegationFee, _data);
        }
        return true;
    }

    function generateAndTransfer(address _generateTo, uint _value, address _transferTo, bytes _data) onlyController public returns (bool) {
        generateTokens(_generateTo, _value);
        transferFromTo(_generateTo, _transferTo, _value, _data);
        return true;
    }

    function ecrecovery(bytes32 hash, bytes sig) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        // FIXME: Should this throw, or return 0?
        if (sig.length != 65) {
            return 0;
        }

        // The signature format is a compact form of:
        //   {bytes32 r}{bytes32 s}{uint8 v}
        // Compact means, uint8 is not padded to 32 bytes.
        assembly {
        r := mload(add(sig, 32))
        s := mload(add(sig, 64))
        v := mload(add(sig, 65))
        }

        // old geth sends a `v` value of [0,1], while the new, in line with the YP sends [27,28]
        if (v < 27) {
            v += 27;
        }

        return ecrecover(hash, v, r, s);
    }

    function ecverify(bytes32 hash, bytes sig, address signer) internal pure returns (bool b) {
        b = ecrecovery(hash, sig) == signer;
        return b;
    }
}