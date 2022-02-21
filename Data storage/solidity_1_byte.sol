pragma solidity ^0.6.0;
// SPDX-License-Identifier: MIT

contract Test {
    mapping(uint8 => uint8) public tests;
     
    function one_set() public {
        tests[0] = 0;
    }

    function one_increment() public {
        tests[0] = tests[0] + 1;
    }
    //  function ten_increment() public {
    //     tests[0] = tests[0] + 10;
    // }
    // function display_value()  view public returns (uint8) {
    //     return tests[0];
    // }
}
 