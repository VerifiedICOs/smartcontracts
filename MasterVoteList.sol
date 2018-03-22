pragma solidity ^0.4.19;

//--------------------------------------------------------------------------------------------------

contract VICOToken {

    string public name = 'VICO Vote Token';
    string public symbol = 'VICO';
    uint256 public decimals = 0;
    uint256 public totalSupply = 100000000;
    address public VicoOwner;
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    event Transfer(address indexed from, address indexed to, uint256 value);

    function VICOToken(address ownerAddress) public {
        balanceOf[msg.sender] = totalSupply;
        VicoOwner = ownerAddress;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require (_to != 0x0);                               
        require (_value >0);
        require (balanceOf[msg.sender] >= _value);           
        require (balanceOf[_to] + _value > balanceOf[_to]);

        balanceOf[msg.sender] -= _value;                     
        balanceOf[_to] += _value;                           
        
        Transfer(msg.sender, _to, _value);                   
        return true;
    }
}

//--------------------------------------------------------------------------------------------------

contract masterList {
    
    uint constant mondayOffset = 345600;
    uint constant oneWeek = 604800;
    
    address[] public listingAddresses;
    
    address public admin;
    address public vicoMintAddress;
    
      function masterList (address _admin, address _vicoMintAddress) public {
        admin = _admin;
        vicoMintAddress = _vicoMintAddress;
    }
    
    function newListing(string _token) public returns (address newListingAddress) {
        require (msg.sender == admin);
        
        uint nextMondayTimestamp = now + mondayOffset - now%oneWeek;
        
        listing newListing = new listing(_token, nextMondayTimestamp, nextMondayTimestamp+oneWeek, admin, vicoMintAddress);
        listingAddresses.push(address(newListing));
        
        return (address(newListing));
    }
}

//--------------------------------------------------------------------------------------------------


contract listing {
    
    string public tokenSymbol;
    uint public startTimestamp;
    uint public endTimestamp;
    
    uint256 public balance;
    
    address public admin;
    address public vicoMintAddress;
    
    function listing(string _token, uint _startTimestamp, uint _endTimestamp, address _admin, address _vicoMintAddress) public {
        tokenSymbol = _token;
        startTimestamp = _startTimestamp;
        endTimestamp = _endTimestamp;
        admin = _admin;
        vicoMintAddress = _vicoMintAddress;
    }
    
    function refund(address[] _to, uint256[] _value) public {
        require (msg.sender == admin);
        require (_value.length == _to.length);
        
        VICOToken vicoMintContract = VICOToken(vicoMintAddress);

        for(uint256 i = 0; i < _to.length; i++) {

            require (vicoMintContract.balanceOf(address(this)) >= _value[i]); 
            require (_to[i] != 0x0);       
            
            vicoMintContract.transfer(_to[i], _value[i]);                           
        }
    } 
    
    function deposit() public {
        require (msg.sender == admin);
        
        VICOToken vicoMintContract = VICOToken(vicoMintAddress);
        balance = vicoMintContract.balanceOf(address(this));
        vicoMintContract.transfer(admin, balance);
    }
}
