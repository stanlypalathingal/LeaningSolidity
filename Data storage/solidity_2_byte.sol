pragma solidity ^0.6.0;
// SPDX-License-Identifier: MIT

contract Test {
    mapping(uint16 => uint16) public tests;
     
    function one_set() public {
        tests[0] = 260;
    }

    function one_increment() public {
        tests[0] = tests[0] + 1;
    }    
}