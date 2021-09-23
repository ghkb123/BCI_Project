import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "./IERC20.sol";
import "./IERC3156FlashBorrower.sol";
import "./IERC3156FlashLender.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract FlashBorrower is IERC3156FlashBorrower {

    enum Action { NORMAL, OTHER}
    IERC3156FlashLender lender;
    IERC20 TK1;
    IERC20 TK2;
    IUniswapV2Router02 sushiSwap;
    ISwapRouter public immutable uniswapV3;

    constructor(IERC3156FlashLender lender_) {
        lender = lender_;
        TK1 = IERC20(0x4a1b06B20D93eaf95D9486a868373234b0055387);
        TK2 = IERC20(0xC372c5f9A0aa679b278f8f8eC7BD8dDE249D889e);
        sushiSwap = IUniswapV2Router02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
        uniswapV3 = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    }

    /// @dev ERC-3156 Flash loan callback
    function onFlashLoan(address initiator, address token, uint256 amount, uint256 fee, bytes calldata data) external override returns (bytes32) {
        require(msg.sender == address(lender), "FlashBorrower: Untrusted lender");
        require(initiator == address(this), "FlashBorrower: Untrusted loan initiator");
        Action action = abi.decode(data, (Action));
        if (action == Action.NORMAL) {
            this.swappitySwap();
        } else if (action == Action.OTHER) {
            // do another
        }
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    /// @dev Initiate a flash loan
    function flashBorrow(address token, uint256 amount) public {
        bytes memory data = abi.encode(Action.NORMAL);
        uint256 _allowance = IERC20(token).allowance(address(this), address(lender));
        uint256 _fee = lender.flashFee(token, amount);
        uint256 _repayment = amount + _fee;
        IERC20(token).approve(address(lender), _allowance + _repayment);
        lender.flashLoan(this, token, amount, data);
    }

    function swappitySwap() public {
        // uint256 amountIn = IERC20(TK1).balanceOf(address(this));
        uint256 amountIn = 100000000000000000000; // 100 tokens
        require(TK1.approve(address(sushiSwap), amountIn), "approve failed.");

        // swap TK1 for TK2 on sushiSwap - price of TK1:TK2 should be lower on sushiSwap than uniswap
        address[] memory path = new address[](2);
        path[0] = address(TK1);
        path[1] = address(TK2);
        sushiSwap.swapExactTokensForTokens(amountIn, 0, path, address(this), block.timestamp);

        // Approve the router to spend TK2.
        TK2.approve(address(uniswapV3), TK2.balanceOf(address(this)));

        // Swap TK2 for TK 1 on uniswap
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
                tokenIn: address(TK2),
                tokenOut: address(TK1),
                fee: 3000,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: TK2.balanceOf(address(this)),
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        // The call to `exactInputSingle` executes the swap.
        uniswapV3.exactInputSingle(params);
    }
}
