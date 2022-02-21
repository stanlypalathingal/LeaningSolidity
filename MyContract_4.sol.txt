//This program enhances the MyContract_3.sol
pragma solidity ^ 0.5.1;

contract MyContract_4{
    uint256 public peopleCount=0;
    mapping(uint => Person) public people; //uses mapping to get the details 
    
    struct Person{
        uint id;
        string firstName;
        string lastName;
    }
    function addPerson(string memory firstName, string memory lastName) public{
        peopleCount+=1;
        people[peopleCount]=Person(peopleCount,firstName,lastName);
    }
}