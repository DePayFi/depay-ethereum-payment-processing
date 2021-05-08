// SPDX-License-Identifier: MIT

pragma solidity >=0.7.5 <0.8.0;
pragma abicoder v2;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';
import './interfaces/IBPool.sol';
import './libraries/Helper.sol';

contract DePayRouterV1BalancerSwap01 {
  using SafeMath for uint256;

  // Address representating ETH (e.g. in payment routing paths)
  address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  // MAXINT to be used only, to increase allowance from
  // payment protocol contract towards known
  // decentralized exchanges, not to dyanmically called contracts!!!
  uint256 public immutable MAXINT = type(uint256).max;

  // Address of bPool
  address public immutable bPool;

  // Address of WETH
  address public immutable WETH;

  // Indicates that this plugin requires delegate call
  bool public immutable delegate = true;

  // Pass _bPool when deploying this contract.
  constructor(address _bPool, address _WETH) {
    bPool = _bPool;
    WETH = _WETH;
  }

  // Swap tokenA<>tokenB, ETH<>ERC20 or ERC20<>ETH on Balancer Exchange.
  // function swapExactAmountIn(
  //   address tokenIn,
  //   uint256 tokenAmountIn,
  //   address tokenOut,
  //   uint256 minAmountOut,
  //   uint256 maxPrice
  // ) external payable;
  function execute(
    address[] calldata path,
    uint256[] calldata amounts,
    address[] calldata addresses,
    string[] calldata data
  ) external payable returns (bool) {

    if (path[0] == ETH) {
      // Swap ETH for WETH
      payable(WETH).transfer(amounts[0]);
      Helper.safeApprove(WETH, bPool, MAXINT);

      // Perform swap
      IBPool(addresses[0]).swapExactAmountIn(WETH, amounts[0], path[path.length - 1], amounts[1], amounts[2]);
      return true;
    } else if (IERC20(path[0]).allowance(address(this), bPool) < amounts[0]) {
      // Make sure swapping the token within the payment protocol contract is approved on the bPool.
      Helper.safeApprove(path[0], bPool, MAXINT);

      // Perform swap
      IBPool(addresses[0]).swapExactAmountIn(path[0], amounts[0], path[path.length - 1], amounts[1], amounts[2]);
      return true;
    }

    return false;
  }
}
