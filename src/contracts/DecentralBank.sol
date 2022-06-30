pragma solidity ^0.8.0;
import "./RWD.sol";
import "./Tether.sol";

contract DecentralBank {
    string public name = "Decentral Bank";
    address public owner;
    RWD public rwd;
    Tether public tether;

    address[] public stakers;

    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaked;

    constructor(RWD _rwd, Tether _tether) {
        rwd = _rwd;
        tether = _tether;
        owner = msg.sender;
    }

    function depositTokens(uint256 _amount) public {
        require(_amount > 0, "amount cannot be zero");

        //Transfer tether tokens to this address for staking
        tether.transferFrom(msg.sender, address(this), _amount);

        //update staking balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        //Update staking balance
        isStaked[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    // issur rewards
    function issueTokens() public {
        require(msg.sender == owner, "caller must be the owner");

        for (uint256 i = 0; i < stakers.length; i++) {
            address recepient = stakers[i];
            uint256 balance = stakingBalance[recepient] / 10; // percentage incentive
            if (balance > 0) {
                rwd.transfer(recepient, balance);
            }
        }
    }
}
