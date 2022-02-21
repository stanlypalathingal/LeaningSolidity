//This program enhances the MyContract_4.sol
//Here only owner can access the contract
pragma solidity ^ 0.5.1;

contract MyContract_5{
    uint256 public peopleCount=0;
    mapping(uint => Person) public people; //uses mapping to get the details 
    
    address owner;
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    constructor() public{
        owner = msg.sender;
    }
    struct Person{
        uint id;
        string firstName;
        string lastName;
    }
    function addPerson(string memory firstName, string memory lastName) public onlyOwner{
        peopleCount+=1;
        people[peopleCount]=Person(peopleCount,firstName,lastName);
    }
}