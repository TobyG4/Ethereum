pragma solidity ^0.4.17;

//contract to create car sharing journeys. Like blablacar
//With a moderator to resolve a disputed journey

contract Journey {
    
    address public driver;
    uint public tripCost;
    string public driveFrom;
    string public driveTo;
    uint public numberPassengers;
    mapping(address => bool) public passengers;
    uint public passengerCount;
    bool public journeyCancelled;
    

    modifier onlyPassenger () {
        require(passengers[msg.sender]);
        _;
    }
    
    modifier onlyDriver () {
        require(msg.sender == driver);
        _;
    }
    

    function Journey(uint cost,string locationfrom,string locationto, uint numberpassengers) public {
        
        driver = msg.sender;
        driveFrom = locationfrom;
        driveTo = locationto;
        tripCost = cost;
        numberPassengers = numberpassengers;
        passengerCount = 0;
        journeyCancelled = false;
        
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
    
    //If driver cancels must payback money to passengers.
    function driverCancelJourney() public onlyDriver {
        journeyCancelled = true;
    }
    
    function passengerRefund() onlyPassenger public {
        require(journeyCancelled);
        msg.sender.transfer(tripCost);
    
    }
        
}
