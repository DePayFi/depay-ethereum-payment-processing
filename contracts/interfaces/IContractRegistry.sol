// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.7.5 <0.8.0;

interface IContractRegistry {
  function getAddress(bytes32 _contractName) external view returns (address);
}

