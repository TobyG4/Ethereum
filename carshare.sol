pragma solidity ^0.4.17;

//contract to create car sharing journeys. Like blablacar
//With a moderator to resolve a disputed journey

contract Journey {
    
    address public driver;
    address public moderator;
    uint public tripCost;
    string public driveFrom;
    string public driveTo;
    uint public numberPassengers;
    mapping(address => bool) public passengers;
    uint public passengerCount;
    

    modifier onlyPassenger () {
        require(passengers[msg.sender]);
        _;
    }
    
    modifier onlyDriver () {
        require(msg.sender == driver);
        _;
    }
    
    modifier onlyModerator () {
        require(msg.sender == moderator);
        _;
    }
    
    function Journey(uint cost,string locationfrom,string locationto, uint numberpassengers,address choosemoderator) public {
        
        driver = msg.sender;
        driveFrom = locationfrom;
        driveTo = locationto;
        tripCost = cost;
        numberPassengers = numberpassengers;
        passengerCount = 0;
        moderator = choosemoderator;
        
    }
    
    function joinJourney() public payable {
        require(msg.value == tripCost);
        require(passengerCount<numberPassengers);
        passengers[msg.sender] = true;
        passengerCount++;

    }
    
    function getSummary() public view returns (
      uint, uint, uint, uint, address
      ) {
        return (
          tripCost,
          address(this).balance,
          numberPassengers,
          passengerCount,
          driver
        );
    }
    
    function journeyComplete() public onlyPassenger {
        driver.transfer(address(this).balance);
    }
    
    //moderator can choose whether the journey was completed succesfully or not.
    //and therefore who receives money
    //function resolveDispute() public onlyModerator (address) {
        
        
        
    //}
        
}
