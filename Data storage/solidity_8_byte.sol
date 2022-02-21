pragma solidity ^0.6.0;
// SPDX-License-Identifier: MIT

contract Test {
    mapping(uint64 => uint64) public tests;
     
    function one_set() public {
        tests[0] = 18446744073709000615;
    }

    function one_increment() public {
        tests[0] = tests[0] + 1;
    }
    //  function ten_increment() public {
    //     tests[0] = tests[0] + 10;
    // }
    
}