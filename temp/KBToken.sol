// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/presets/ERC20PresetMinterPauser.sol";
import "@openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol";

contract KBToken1 is ERC20PresetMinterPauser {
    constructor() public ERC20PresetMinterPauser("KB 0913 Token 1", "KB0913TK1") {}
}
contract KBToken2 is ERC20PresetMinterPauser {
    constructor() public ERC20PresetMinterPauser("KB 0913 Token 2", "KB0913TK2") {}
}