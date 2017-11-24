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
/// @author Bezalel Lim <bezalel@yosemitex.com>

import "./DigitalCurrencyTokenBase.sol";

contract DKRWToken is DigitalCurrencyTokenBase {

    mapping (address => uint256) nonces;

    /// @notice DKRWToken constructor
    /// @param _tokenFactory The address of the SnapshotableTokenFactory contract that
    ///   will create the Clone token contracts, the token factory needs to be deployed first
    function DKRWToken(
        address _tokenFactory
    ) public DigitalCurrencyTokenBase(
        _tokenFactory,
        0x0,               // no parent token
        0,                 // no snapshot block number from parent
        "dKRW Test Token", // Token name
        18,                // Decimals
        "DKRW",            // Symbol
        true               // Enable transfers
    ) {}
}