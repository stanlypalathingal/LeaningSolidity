pragma solidity ^0.6.0;
// SPDX-License-Identifier: MIT

contract Test {
    mapping(uint32 => uint32) public tests;
     
    function one_set() public {
        tests[0] = 4294967000;
    }

    function one_increment() public {
        tests[0] = tests[0] + 1;
    }
    //  function ten_increment() public {
    //     tests[0] = tests[0] + 10;
    // }
    
}