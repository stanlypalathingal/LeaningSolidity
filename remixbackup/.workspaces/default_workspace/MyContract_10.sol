// this is to create libraries
// here the libary Math_Library iosa called by importing

pragma solidity 0.5.1;

import "./Math_Library.sol";
contract MyContract_10{
    uint256 public value;
    function calculate (uint256 _value1,uint256 _value2) public {
        value = Math.divide(_value1,_value2);
    }
    
}
