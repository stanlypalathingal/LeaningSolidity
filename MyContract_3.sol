//This program add the structure person with the two fields
pragma solidity ^ 0.5.1;

contract MyContract_3{
    Person[] public people;
    uint256 public peopleCount;
    
    struct Person{
        string firstName;
        string lastName;
    }
    function addPerson(string memory firstName, string memory lastName) public{
        people.push(Person(firstName,lastName));
        peopleCount+=1;
    }
}