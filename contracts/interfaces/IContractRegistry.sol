// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

interface IContractRegistry {
  function getAddress(bytes32 _contractName) public view returns (address);
}

