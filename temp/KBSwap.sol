pragma solidity 0.6.12;
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import {IERC20} from "./Dependencies/Interfaces.sol";

contract KBSwap {
    function test() public {
        IERC20 DAI       = IERC20(0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa);
        IERC20 WETH      = IERC20(0xc778417E063141139Fce010982780140Aa0cD5Ab);
        IERC20 UNI       = IERC20(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984);

        IERC20 KB0913TK1 = IERC20(0xdff2F041022656067251AC8A55f83083603C1B40);
        IERC20 KB0913TK2 = IERC20(0xE2f4Ed7674784ec3e8C02C3AC24f6F66aEceB4a4);

        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uint amountIn = 5 * 10 ** 18;

        // require(DAI.transferFrom(msg.sender, address(this), amountIn), 'transferFrom failed.');
        // require(DAI.approve(address(uniswapV2Router), amountIn), 'approve failed.');
        KB0913TK1.approve(address(uniswapV2Router), amountIn);

        address[] memory path = new address[](2);
        path[0] = address(KB0913TK1);
        // path[1] = uniswapV2Router.WETH();
        path[1] = address(KB0913TK2);
        uniswapV2Router.swapExactTokensForTokens(amountIn, 0, path, address(0x9DC2523014fE6Aff8ac825617504e64937AB2692), block.timestamp);
        // uniswapV2Router.swapExactTokensForETH(amountIn, 0, path, address(0x9DC2523014fE6Aff8ac825617504e64937AB2692), block.timestamp);
    }
}
