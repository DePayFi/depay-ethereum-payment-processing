// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.7.5 <0.8.0;

interface IBancorNetwork {
  function onversionPath(address _sourceToken, address _targetToken)
    external
    view
    returns (address[] memory);

  function rateByPath(address[] memory path, uint256 amount) external view returns (uint256);

  function convertByPath(
    address[] memory path,
    uint256 amount,
    uint256 minReturn,
    address payable beneficiary,
    address affiliateAccount,
    uint256 affiliateFee
  ) external payable returns (uint256);
}
