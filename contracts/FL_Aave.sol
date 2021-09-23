// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import {FlashLoanReceiverBase} from "./Dependencies/FlashLoanReceiverBase.sol";
import {ILendingPool, ILendingPoolAddressesProvider} from "./Dependencies/FlashInterfaces.sol";
import {SafeMath} from "./Dependencies/Libraries.sol";
import {IERC20, IProtocolDataProvider, IStableDebtToken} from "./Dependencies/Interfaces.sol";

contract MyV2FlashLoan is FlashLoanReceiverBase {
    using SafeMath for uint256;
    ILendingPool LENDING_POOL;

    // address public kovanUsdc = 0xe22da380ee6B445bb8273C81944ADEB6E8450422;
    address public aave_lending_poolv2_kovan = address(0x88757f2f99175387aB4C6a4b3067c77A695b0349);
    address public contractAddress = address(this);

    constructor(ILendingPoolAddressesProvider _addressProvider) public FlashLoanReceiverBase(_addressProvider)
    { LENDING_POOL = _lendingPool;}

    /**
        This function is called after your contract has received the flash loaned amount
     */
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {

        // *** Do whatever you want with the flash liquidity here ***
        // Approve the LendingPool contract allowance to *pull* the owed amount

        for (uint256 i = 0; i < assets.length; i++) {
            uint256 amountOwing = amounts[i].add(premiums[i]);
            IERC20(assets[i]).approve(address(LENDING_POOL), amountOwing);
        }
        return true;
    }

    function myFlashLoanCall(address _tokenAddress, uint256 _loanAmount, uint256 _loanFee) public {
        address receiverAddress = address(this);

        address[] memory assets = new address[](1);
        assets[0] = _tokenAddress;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = _loanAmount;

        IERC20(assets[0]).transferFrom(msg.sender, address(this), _loanFee);
        
        uint256[] memory modes = new uint256[](1);
        modes[0] = 0;

        address onBehalfOf = address(this);
        bytes memory params = "";
        uint16 referralCode = 0;

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
