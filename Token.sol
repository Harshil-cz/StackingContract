// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("Crown", "crn") {}

    function mint(address owner, uint amount) public {
        _mint(owner, amount);
    }
}