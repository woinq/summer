pragma solidity >=0.8.2 <0.9.0;


 
contract ElectroSamokat {
    constructor(){
        samokatAdmin=msg.sender;
    }

    uint amountSamokats = 0;
    address samokatAdmin;
uint public priceForDay = 1000 gwei;

    struct Samokat {
        string number;
        string geolocation;
        string charging;
        bool availability;

    }

    struct User {
        uint age ;
        bool license;

    }
    mapping (address => User) user;
    mapping (uint=> Samokat) samokatNumber;
    mapping (uint=> address) rentedTo;

    //-----------Admin

    function changeAdmin(address _newAdmin) public {
        require(samokatAdmin==msg.sender, "Only admin");
        samokatAdmin = _newAdmin;


    }

    function withdraw() public {
        require(samokatAdmin==msg.sender,"Only admin");
        payable(samokatAdmin).transfer(address(this).balance);
    }
    //--------Samokat
    function createSamokat(string calldata _number, string calldata _geolocation, string calldata _charging) public returns(uint) {
        require(samokatAdmin==msg.sender, "Only admin");
        //samokat create 
        samokatNumber[amountSamokats] = Samokat(_number, _geolocation, _charging, true);
        amountSamokats++;
        return amountSamokats-1;

    }

    function samokatInfo(uint _samokatID) public view returns (Samokat memory){
        require(_samokatID<amountSamokats, "Not exist");
        return samokatNumber [_samokatID];
    }

    function rentSamokat(uint _samokatID, uint _day) public payable{
        require(_samokatID<amountSamokats, "Not exist");
        require(priceForDay*_day==msg.value, "Not enough funds");
        require(user[msg.sender].license ==true, "No license") ;
        require (user[msg.sender].age >=18,  "Too Young");
       // require(rentedTo[_samokatID]==0x0000000000000000000000000000000000000000, "Already rented");
       require(samokatNumber[_samokatID].availability, "Already rented");
        rentedTo[_samokatID] = msg.sender;
        samokatNumber[_samokatID].availability = false;
    }

    function registration (uint age, bool license) public {
        user[msg.sender] = User(age, license);
    }

    function whereIsSamokat(uint _samokatID) public view returns (address){
        require(_samokatID<amountSamokats, "Not exist");
        return rentedTo[_samokatID];
     }

     function returnSamokat(uint _samokatID) public {
         require(msg.sender==samokatAdmin || msg.sender ==rentedTo[_samokatID], "Only admin");
         samokatNumber [_samokatID].availability = true;
         delete rentedTo[_samokatID];

     }


}
