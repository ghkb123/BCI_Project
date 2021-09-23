pragma solidity 0.6.12;
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import {IERC20} from "./Dependencies/Interfaces.sol";

contract SushiSwap {
    function test() public {
        IERC20 KB0913TK1 = IERC20(0xdff2F041022656067251AC8A55f83083603C1B40);
        IERC20 KB0913TK2 = IERC20(0xE2f4Ed7674784ec3e8C02C3AC24f6F66aEceB4a4);

        // IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        IUniswapV2Router02 sushiSwapV2Router = IUniswapV2Router02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
        uint amountIn = 5 * 10 ** 18;

        KB0913TK2.approve(address(sushiSwapV2Router), amountIn);

        address[] memory path = new address[](2);
        path[0] = address(KB0913TK2);
        path[1] = address(KB0913TK1);
        sushiSwapV2Router.swapExactTokensForTokens(amountIn, 0, path, address(0x9DC2523014fE6Aff8ac825617504e64937AB2692), block.timestamp);
    }
}
