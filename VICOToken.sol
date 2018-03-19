pragma solidity ^0.4.19;

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
