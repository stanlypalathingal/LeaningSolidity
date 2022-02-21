pragma solidity ^0.4.9;

contract MyContract {
    string value;
    function get() public returns(string){
        return value;
    }
}