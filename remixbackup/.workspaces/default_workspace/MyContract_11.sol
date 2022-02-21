// uses the SafeMath_Library file which is from openZeppelin library

pragma solidity 0.8.0;
// SPDX-License-Identifier: MIT

import "./SafeMath_Library.sol";

contract MyContract_11 {
    using SafeMath for uint256;
    uint256 public value;
    
    function calculate(uint256 _value1, uint256 _value2) public {
        value = _value1.div(_value2);
    }
}
