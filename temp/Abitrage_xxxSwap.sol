// https://docs.uniswap.org/protocol/V2/guides/smart-contract-integration/trading-from-a-smart-contract
// https://cryptomarketpool.com/how-do-the-uniswap-solidity-smart-contracts-work/
// https://soliditydeveloper.com/uniswap2
// https://soliditydeveloper.com/multiswap
// https://vomtom.at/how-to-use-uniswap-v2-as-a-developer/

// 
// https://cryptomarketpool.com/flash-loan-arbitrage-on-uniswap-and-sushiswap/
// https://github.com/Austin-Williams/uniswap-flash-swapper/blob/master/contracts/UniswapFlashSwapper.sol
// https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/examples/ExampleFlashSwap.sol

pragma solidity 0.6.12;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
// import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {FlashLoanReceiverBase} from "./Dependencies/FlashLoanReceiverBase.sol";
import {ILendingPool, ILendingPoolAddressesProvider} from "./Dependencies/FlashInterfaces.sol";
import {SafeMath} from "./Dependencies/Libraries.sol";
import {IERC20} from "./Dependencies/Interfaces.sol";
        
contract Abitrage_xxxSwap {

    // ILendingPoolAddressesProvider lender;
    // Aave V2 lending pool address on Kovan
    // address public aave_lending_poolv2_kovan = address(0x88757f2f99175387aB4C6a4b3067c77A695b0349);

    // Uniswap V2 router02 (UniswapV2Router02) address on Kovan
    // https://docs.uniswap.org/protocol/V2/reference/smart-contracts/router-02
    // address internal constant UNISWAP_ROUTER_ADDRESS = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    // ?? Uniswap V3 router address on Kovan
    // ?? https://github.com/Uniswap/v3-periphery/blob/main/deploys.md
    // ?? address internal constant UNISWAP_ROUTER_ADDRESS = address(0xE592427A0AEce92De3Edee1F18E0157C05861564);

    // Sushiswap V2 router02 (SushiV2Router02) address at Kovan 
    // https://dev.sushi.com/sushiswap/contracts#sushiv-2-router02-1
    // address internal constant SUSHISWAP_ROUTER_ADDRESS = address(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);

    // ?? address public kovanDAI = 0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD;
    // MakerDAO DAI at Kovan (18 Decimals)
    // address public kovanDAI = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa;
    // https://github.com/makerdao/developerguides/blob/master/dai/dai-token/dai-token.md
 

    ILendingPoolAddressesProvider lender;
    // KB Token @ ringkeby
    IERC20 KB0913TK1 = IERC20(0xdff2F041022656067251AC8A55f83083603C1B40);
    IERC20 KB0913TK2 = IERC20(0xE2f4Ed7674784ec3e8C02C3AC24f6F66aEceB4a4);

    // KB Token @ kovan
    // IERC20 KB0913TK1 = IERC20(0xc68A7b823168432217BC7025B28F3FC49a59c5Fc);
    // IERC20 KB0913TK2 = IERC20(0x9491459B5B6E361B33eaDf30A5C196d79F2f78f3);

    //IERC20 WETH = IERC20(0xd0A1E359811322d97991E03f863a0C30C2cF029C);
    //IERC20 USDT = IERC20(0x07de306FF27a2B630B1141956844eB1552B956B5);
    //IERC20 USDC = IERC20(0xe22da380ee6b445bb8273c81944adeb6e8450422);    
    IUniswapV2Router02 uniSwap  = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    // uniSwap = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    IUniswapV2Router02 sushiswapRouter = IUniswapV2Router02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);

    // ISwapRouter public immutable uniswapV3;

// constructor(ILendingPoolAddressesProvider lender_) public {
//          lender = lender_;
//          KB0913TK1 = IERC20(0xc68A7b823168432217BC7025B28F3FC49a59c5Fc);
//          KB0913TK2 = IERC20(0x9491459B5B6E361B33eaDf30A5C196d79F2f78f3);

        
//          //SushiV2Router02 contract address at Kovan
//          uniSwap = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
//          // uniswapV3 = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
// }

function transferFrom() public {
    // Before swapping, our smart contracts needs to be in control of KB0913TK1
    //   transferFrom(sender, recipient, amount)
    //      Moves amount tokens from sender to recipient using the allowance mechanism. 
    //      amount is then deducted from the caller’s allowance.
    //      msg.sender will be the person who currently connecting with the contract.
    uint256 amountIn = 10000000000000000000; // 10 tokens
    KB0913TK1.transferFrom(msg.sender, address(this), amountIn);
}

function approve(address _spender, uint256 _amountIn) public {
    // Approve to the router to withdraw KB0913TK1
    //      approve(spender, amount)
    //      spender: 
    uint256 amountIn = _amountIn;
    address spender = _spender;
    KB0913TK1.approve(spender, amountIn);
}   

function swapA() public {
    uint256 amountIn = 10000000000000000000; // 10 tokens
    address[] memory path = new address[](2);
    path[0] = address(KB0913TK1);
    path[1] = address(KB0913TK2);
    uniSwap.swapExactTokensForTokens(amountIn, 0, path, address(this), block.timestamp);
}

function swapB() public {
    uint256 amountIn = 10000000000000000000; // 10 tokens
    address[] memory path = new address[](2);
    path[0] = address(KB0913TK1);
    path[1] = address(KB0913TK2);
    uniSwap.swapExactTokensForTokens(amountIn, 0, path, msg.sender, block.timestamp);
}

// function swapC() public {
//     uint256 amountIn = 10000000000000000000; // 10 tokens
//     address[] memory path = new address[](2);
//     path[0] = address(KB0913TK1);
//     path[1] = address(KB0913TK2);
//     uniSwap.swapExactTokensForETH(amountIn, 0, [address(KB0913TK1), address(KB0913TK2)], msg.sender, block.timestamp);
// }

function swappitySwap() public {
        // uint256 amountIn = IERC20(KB0913TK1).balanceOf(address(this));
        // uint256 amountIn = 10 000 0000 000 000 000 000; // 100 tokens
         uint256 amountIn = 10000000000000000000; // 10 tokens
        
        // require(KB0913TK1.approve(address(uniSwap), amountIn), "approve failed.");
        // require(KB0913TK1.transferFrom(msg.sender, address(this), amountIn), 'transferFrom failed.');
        // require(KB0913TK1.approve(address(uniSwap), amountIn), 'approve failed.');
        KB0913TK1.approve(address(uniSwap), amountIn);
//      
        // swap KB0913TK1 for KB0913TK2 on uniSwap - price of KB0913TK1:KB0913TK2 should be lower on uniSwap than uniswap
         address[] memory path = new address[](2);
         path[0] = address(KB0913TK1);
         path[1] = address(KB0913TK2);
         uniSwap.swapExactTokensForTokens(amountIn, 0, path, address(this), block.timestamp);

//         // Approve the router to spend KB0913TK2.
//         KB0913TK2.approve(address(uniswapV3), KB0913TK2.balanceOf(address(this)));

//         // // Swap KB0913TK2 for KB0913TK 1 on uniswap
//         // ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
//         //         tokenIn: address(KB0913TK2),
//         //         tokenOut: address(KB0913TK1),
//         //         fee: 3000,
//         //         recipient: address(this),
//         //         deadline: block.timestamp,
//         //         amountIn: KB0913TK2.balanceOf(address(this)),
//         //         amountOutMinimum: 0,
//         //         sqrtPriceLimitX96: 0
//         //     });

//         // The call to `exactInputSingle` executes the swap.
//         uniswapV3.exactInputSingle(params);
//     }
}

//this.swappitySwap();


function test() public {
     IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
     IUniswapV2Router02 sushiswapRouter = IUniswapV2Router02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
      
     IERC20 WETH = IERC20(0xd0A1E359811322d97991E03f863a0C30C2cF029C);
     IERC20 DAI = IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);
     IERC20 USDT = IERC20(0x07de306FF27a2B630B1141956844eB1552B956B5);
        
     address[] memory path = new address[](2);
     path[0] = address(WETH);
     path[1] = address(USDT);
        
     uint256 amount = 0.01 ether;
     
     // uint256 deadline = getDeadline();
        
     WETH.approve(address(uniswapV2Router), amount);
     // uint256 output = uniswapV2Router.swapExactTokensForTokens(amount, 0, path, address(this), deadline)[1];
     uniswapV2Router.swapExactTokensForTokens(amount, 0, path, address(this), block.timestamp);       
     // USDT.approve(address(sushiswapRouter), output); //This bitch
}


}