// SPX-Lisence-Identifier: MIT

pragma solidity ^0.8.0;

import './AccessControl.sol';
import '@openzeppelin/contracts/utils/Address'

contract Birthday is AccessControl  {
        
        using Address for address payable;
        
        // Adress of familly 
        address private _familly;
        // Address of the doctor
        address private _doctor;
        
        mapping(address => uint256) private _friendsBalances;
        mapping(address => bool) private _friendVoted;
        
        uint256 private _blockTime;
        uint256 private _unlockTime;
        uint256 private _birthDayDate;
        
        // The variable _iscariotCount will count how many times the friends voted to retrieve their money if, 
        // for exemple, they're not friend with the recipient anymore
        // if 51% of the friends voted to retrive, then, _iscariot will be true, and then, the funds can be retrieved by all the friends.
        uint256 private _iscariotCount;
        bool private _iscariot;
        
        
        // The variable _deadRecipient checks if the recipients is dead, if it is so, both _iscariot and _deadRecipient will have to be true
        // in order for users to retrieves their funds, if not, the funds will be sent to the familly (split in half)
        bool private _deadRecipient;
        
        // Events
        event Deposited(address indexed sender, uint256 amount);
       
        constructor (address owner_) AccessControl(owner_) {
          _blockTime = block.timestamp; 
          _birthDayDate = 1610317533;
          _unlockTime =  _blockTime + 5 minutes;
          _iscariot = false;
          _deadRecipient =  false;
          // Bob is the father of the Recipient : 
          _familly = 0xAF412a4D6CD840201576Fd5c7e1F3529e6486d3D;
          _doctor = 0xB402e72B64fCf5466A212A02e06C87Ff74d4687d;
        }


        function getBlockTime() public view returns(uint256) {
            return _blockTime;
        }
        
        function getCurrentTime() public view returns(uint256) {
            return block.timestamp;
        }
        
        function hasVoted(address friends) public view onlyOwner returns(bool) {
            return _friendVoted[friends];
        }
        
        function iscariotVote() public onlyFriend {
            require(_numberOfFriends > _iscariotCount, 'test');
            _iscariotCount++;
            _friendVoted[msg.sender] = true;
        }
        
        function iscariotWithdrawal() public payable onlyFriend onlyIscariot {
            uint256 iscariotFunds = _friendsBalances[msg.sender];
            _friendsBalances[msg.sender] -= 0;
            payable(msg.sender).sendValue(iscariotFunds);
        }
        
        function withdraw() public payable onlyOwner {
           _withdraw();
        }        
        
        receive() external payable {
             deposit();
        }
        
        function deposit() public payable onlyFriend {
             emit Deposited(msg.sender, msg.value);
        }
        
        function _withdraw() private onlyRecipient {
           require(_iscariot == false, 'Birthday: sorry, your friends decided to lock the funds.');
           payable(msg.sender).sendValue(address(this).balance);
        }
       
}








