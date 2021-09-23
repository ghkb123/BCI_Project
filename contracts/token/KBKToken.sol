// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol";

contract KBKToken1 is ERC20PresetMinterPauser {
    constructor() public ERC20PresetMinterPauser("KBK 0919 Token 1", "KBK0919TK1") {}
}
contract KBKToken2 is ERC20PresetMinterPauser {
    constructor() public ERC20PresetMinterPauser("KBK 0919 Token 2", "KBK0919TK2") {}
}
