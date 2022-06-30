pragma solidity ^0.8.0;

contract RWD {
   string public name =  "Reward Token";
   string public symbol = "RWD";
   uint256 public totalSupply = 1000000000000000000000000; // a million tokens
   uint8 public decimals = 18;

   event Transfer(
       address indexed _from,
       address indexed _to,
       uint _value
   );

   event Approve(
       address indexed _owner,
       address indexed _spender,
       uint _value
   );

   mapping(address => uint) public balanceOf;
   mapping(address => mapping(address => uint)) public allowance;

   constructor() public {
       balanceOf[msg.sender] = totalSupply;
   }

   function transfer(address _to, uint _value) public returns (bool success) {
       // the value in the bank must be greater than that for transfer
       require(balanceOf[msg.sender] >= _value);
       // transfer the amount and subtract the balance 
       balanceOf[msg.sender] -= _value;
       // add the balance from sender to receiver
       balanceOf[_to] += _value;
       emit Transfer(msg.sender, _to, _value);
       return true;
   }

   function approved(address _spender, uint _value) public returns (bool success) {
       allowance[msg.sender][_spender] = _value;
       emit Approve(msg.sender, _spender, _value);
       return true;
   }

   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
       require(_value <= balanceOf[_from], 'utility');
       require(_value <= allowance[_from][msg.sender], 'utilities');
       // add the balance from sender to receiver
       balanceOf[_to] += _value;
       // add the balance from receiver to sender
       balanceOf[_from] -= _value;
       allowance[msg.sender][_from] -= _value;
       emit Transfer(_to, _from, _value);
       return true;
   }
} 