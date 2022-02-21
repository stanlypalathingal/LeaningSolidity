//This is to demonstate a transaction 
pragma solidity 0.5.1;

contract MyContract_7 {
    mapping (address => uint256) public balances;
    address payable wallet;
    event Purchase(address _buyer, uint256 _amount);
    
    constructor(address payable _wallet) public {
        wallet=_wallet;
    }
    
    function() external payable{
        buyToken();
    }
    function buyToken() public payable{
        balances[msg.sender] +=1; // buy a token
        wallet.transfer(msg.value);
        //send an ether to wallet
        emit Purchase(msg.sender,1);
    }
}