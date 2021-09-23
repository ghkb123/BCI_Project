// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import {FlashLoanReceiverBase} from "./Dependencies/FlashLoanReceiverBase.sol";
import {ILendingPool, ILendingPoolAddressesProvider} from "./Dependencies/FlashInterfaces.sol";
import {SafeMath} from "./Dependencies/Libraries.sol";
import {IERC20, IProtocolDataProvider, IStableDebtToken} from "./Dependencies/Interfaces.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract FL_Arbitrage is FlashLoanReceiverBase {

    using SafeMath for uint256;
    ILendingPool LENDING_POOL;

    address public aave_lending_poolv2_kovan = address(0x88757f2f99175387aB4C6a4b3067c77A695b0349);
    IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    IUniswapV2Router02 sushiSwapV2Router = IUniswapV2Router02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
    address public contractAddress = address(this);
    
    constructor(ILendingPoolAddressesProvider _addressProvider) public FlashLoanReceiverBase(_addressProvider) 
    { LENDING_POOL = _lendingPool;}

    // /**
    //  * This function is called after your contract has received the flash loaned amount
    //  * @param premium The fee flash borrowed
    //  * initiator of the transaction on flashLoan()
    //  **/
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {

        // *** Do whatever you want with the flash liquidity here ***
        address profitReceiver = address(0x9DC2523014fE6Aff8ac825617504e64937AB2692);
        address[] memory path = new address[](2);
        
        // set the mispriced token
        IERC20 KBK0919TK1 = IERC20(0x0662340314cFc736aC18A0c71b950BF2c35e8D9C);

        // Swap assets[0] (KovanDAI borrowed from Aave) to KBK0919TK1 at uniswapV2
        IERC20(assets[0]).approve(address(uniswapV2Router), amounts[0]);
        path[0] = address(assets[0]);
        path[1] = address(KBK0919TK1);
        uniswapV2Router.swapExactTokensForTokens(amounts[0], 0, path, address(this), block.timestamp);

        // Swap KBK0919TK1 back to assets[0](KovanDAI) at sushiswapV2
        KBK0919TK1.approve(address(sushiSwapV2Router),  KBK0919TK1.balanceOf(address(this)));
        path[0] = address(KBK0919TK1);
        path[1] = address(assets[0]);
        sushiSwapV2Router.swapExactTokensForTokens(KBK0919TK1.balanceOf(address(this)), 0, path, address(this), block.timestamp);

        // Approve the LendingPool contract allowance to *pull* the owed amount
        uint256 amountOwing = amounts[0].add(premiums[0]);
        IERC20(assets[0]).approve(address(LENDING_POOL), amountOwing);
        
        // // to avoid "griefing" attack, transfer profit back to me if there is any
        // if (IERC20(assets[0]).balanceOf(address(this)) > 0) {
        //     IERC20(assets[0]).transfer(msg.sender, IERC20(assets[0]).balanceOf(address(this)));
        //  }

        return true;
    }

    function myFlashLoanCall(address _loanToken, address _mispricedToken, uint256 _loanAmount, uint256 _loanFee) public {

        address receiverAddress = address(this);
        address mispricedToken = address(_mispricedToken);

        address[] memory assets = new address[](1);
        assets[0] = _loanToken;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = _loanAmount;

        IERC20(assets[0]).transferFrom(msg.sender, address(this), _loanFee);
        
        uint256[] memory modes = new uint256[](1);
        modes[0] = 0;

        address onBehalfOf = address(this);
        bytes memory params = "";
        uint16 referralCode = 0;

        /**
        * @dev Allows smartcontracts to access the liquidity of the pool within one transaction,
        * as long as the amount taken plus a fee is returned.
        * IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept into consideration.
        * For further details please visit https://developers.aave.com
        * @param receiverAddress The address of the contract receiving the funds, implementing the IFlashLoanReceiver interface
        * @param assets The addresses of the assets being flash-borrowed
        * @param amounts The amounts amounts being flash-borrowed
        * @param modes Types of the debt to open if the flash loan is not returned:
        *   0 -> Don't open any debt, just revert if funds can't be transferred from the receiver
        *   1 -> Open debt at stable rate for the value of the amount flash-borrowed to the `onBehalfOf` address
        *   2 -> Open debt at variable rate for the value of the amount flash-borrowed to the `onBehalfOf` address
        * @param onBehalfOf The address  that will receive the debt in the case of using on `modes` 1 or 2
        * @param params Variadic packed params to pass to the receiver as extra information
        * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
        *   0 if the action is executed directly by the user, without any middle-man
        **/
        LENDING_POOL.flashLoan(
            receiverAddress,
            assets,
            amounts,
            modes,
            onBehalfOf,
            params,
            referralCode
        );

    }
}
