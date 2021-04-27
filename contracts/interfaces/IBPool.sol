// SPDX-License-Identifier: MIT

pragma solidity >=0.7.5;

interface IBPool {
  function isPublicSwap() external view returns (bool);

  function isFinalized() external view returns (bool);

  function isBound(address t) external view returns (bool);

  function getSpotPrice(address tokenIn, address tokenOut) external view returns (uint256 spotPrice);

  function swapExactAmountIn(
    address tokenIn,
    uint256 tokenAmountIn,
    address tokenOut,
    uint256 minAmountOut,
    uint256 maxPrice
  ) external payable;
}
