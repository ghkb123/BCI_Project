// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import {IERC20} from "./Dependencies/Interfaces.sol";

// KBK0919TK1    0x0662340314cFc736aC18A0c71b950BF2c35e8D9C
// KBK0919TK2    0x1a598cA3602f0BC8f284a6B1b6c8397779246f7A
// Cloned UniswapV2Router02 Address    0x47282E3e18c8503226D7669bcAB12Ab316e403f2

contract KBAbitrage {
    function test() public {

        address leg2OutReceiver = address(0x9DC2523014fE6Aff8ac825617504e64937AB2692);
        IERC20 KBK0919TK1 = IERC20(0x0662340314cFc736aC18A0c71b950BF2c35e8D9C);
        IERC20 KBK0919TK2 = IERC20(0x1a598cA3602f0BC8f284a6B1b6c8397779246f7A);
        IERC20 KovanUSDC = IERC20(0xe22da380ee6B445bb8273C81944ADEB6E8450422);
        IERC20 KovanDAI = IERC20(0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD);
        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        IUniswapV2Router02 sushiSwapV2Router = IUniswapV2Router02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
        // IUniswapV2Router02 clonedSwapV2Router = IUniswapV2Router02(0x47282E3e18c8503226D7669bcAB12Ab316e403f2);

        // mock prices
        // uniswap: 0.8 DAI per KBK0919TK1
        // sushiSwap: 1.2 DAI per KBK0919TK1
        // cloneSwap: 
       


        // **********************************
        // Check if the swap is profitable <== to do 
        // **********************************
        // Leg_2(amountOut) - Leg_1(amountIn) - Fee > 0
        // leg2Out - leg1In - feeOwned2AaveV2 > 0
        // 
        // *************
        // LEG ONE 
        // *************
        // path[0] = address(KBK0919TK1);
        // path[1] = address(KBK0919TK2);
        // leg1In = amountIn = loanAmountFrAaveV2 (amount loaned from Flash Loan provider)
        // leg1Out = uniSwapV2Router.getAmountsOut(leg1In, path)
        //  
        // *************
        // LEG TWO
        // *************
        // path[0] = address(KBK0919TK2);
        // path[1] = address(KBK0919TK1);
        // leg2In = leg1Out;
        // leg2Out = sushiSwapV2Router.getAmountsOut(leg2In, path)
        // 
        // feeOwned2AaveV2 = Aave V2 Fee: 0.09% = 9 / 10000 ( 900 for 1M)
        // 
        // required(leg2Out - leg1In - feeOwned2AaveV2 > 0, "unprofitable deal!" ) 
        // 

        address[] memory path = new address[](2);
        uint amountIn = 10 * 10 ** 18;
        // uint leg1Out;
        // uint leg2Out;

        // top up this SC with KovanDAI
        KovanDAI.transferFrom(msg.sender, address(this), amountIn);

        // Swap KovanDAI to KBK0919TK1 at uniswapV2
        KovanDAI.approve(address(uniswapV2Router), amountIn);
        path[0] = address(KovanDAI);
        path[1] = address(KBK0919TK1);
        uniswapV2Router.swapExactTokensForTokens(amountIn, 0, path, address(this), block.timestamp);
        // leg1Out = uniswapV2Router.getAmountsOut(amountIn, path);

        // Swap KBK0919TK1 back to KovanDAI at sushiswapV2
        // KBK0919TK2.approve(address(sushiSwapV2Router), leg1Out);
        KBK0919TK1.approve(address(sushiSwapV2Router), KBK0919TK1.balanceOf(address(this)));
        path[0] = address(KBK0919TK1);
        path[1] = address(KovanDAI);
        // sushiSwapV2Router.swapExactTokensForTokens(leg1Out, 0, path, leg2OutReceiver, block.timestamp);
        sushiSwapV2Router.swapExactTokensForTokens(
            KBK0919TK1.balanceOf(address(this)), 
            0, 
            path, 
            leg2OutReceiver,
            block.timestamp
            );
    }
}
