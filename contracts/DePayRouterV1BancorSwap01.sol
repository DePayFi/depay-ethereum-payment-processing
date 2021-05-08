// SPDX-License-Identifier: MIT

pragma solidity >=0.7.5 <0.8.0;
pragma abicoder v2;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';
import './interfaces/IBancorNetwork.sol';
import './libraries/Helper.sol';

contract DePayRouterV1BancorSwap01 {
  using SafeMath for uint256;

  // Address representating ETH (e.g. in payment routing paths)
  address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  // MAXINT to be used only, to increase allowance from
  // payment protocol contract towards known
  // decentralized exchanges, not to dyanmically called contracts!!!
  uint256 public immutable MAXINT = type(uint256).max;

  // Address of Uniswap router.
  address public immutable BancorNetwork;

  // Indicates that this plugin requires delegate call
  bool public immutable delegate = true;

  // Pass BancorNetwork when deploying this contract.
  constructor(address _BancorNetwork) public {
    BancorNetwork = _BancorNetwork;
  }

  // Swap tokenA<>tokenB, ETH<>tokenA or tokenA<>ETH on BancorNetwork as part of the payment.
  // Path is BancorNetwork's routing path result of: 
  function execute(
    address[] calldata path,
    uint256[] calldata amounts,
    address[] calldata addresses,
    string[] calldata data
  ) external payable returns (bool) {
    // Make sure swapping the token within the payment protocol contract is approved on the Uniswap router.
    if (path[0] != ETH && IERC20(path[0]).allowance(address(this), BancorNetwork) < amounts[0]) {
      Helper.safeApprove(path[0], BancorNetwork, MAXINT);
    }

    // Executes ETH<>tokenA, tokenA<>ETH, or tokenA<>tokenB swaps depending on the provided path.
    if (path[0] == ETH) {
      IBancorNetwork(BancorNetwork).convertByPath{value: amounts[0]}(
        path,
        amounts[0],
        amounts[1],
        payable(address(this)),
        address(0),
        0
      );
      return true;
    } else {
      IBancorNetwork(BancorNetwork).convertByPath(path, amounts[0], amounts[1], payable(address(this)), address(0), 0);
      return true;
    }
    return false;
  }
}
