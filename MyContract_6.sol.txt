//This program enhances the MyContract_5.sol
//Here the contract is opened only for a certain duration ony
// there are no perfect time to 
pragma solidity ^ 0.5.1;

contract MyContract_6{
    uint256 public peopleCount=0;
    uint256 openingTime=1634740000;
    mapping(uint => Person) public people; //uses mapping to get the details 
    
    modifier onlyWhileOpen(){
        require(block.timestamp >=openingTime);
        _;
    }
    

    struct Person{
        uint id;
        string firstName;
        string lastName;
    }
    function addPerson(string memory firstName, string memory lastName) public onlyWhileOpen{
        peopleCount+=1;
        people[peopleCount]=Person(peopleCount,firstName,lastName);
    }
}