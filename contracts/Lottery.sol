// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "./StackedToadz.sol";

/*write a contract called Lottery that enters users into a raffle from the StackedToadz.sol contract
and then allows them to claim their prize.*/
contract Lottery  {

    event EventJoin(uint _length, uint _qty);
    event EventDraw(address _winner, uint _prize);
    event EventPaid(address _from, uint _value);

    //uints 
    uint256 public PRIZE = 10000000000000000; // the PRIZE is 0.1 ether
    uint public PRICE;
    uint public MAX_TICKETS;
    address public CREATOR;
    address[] public CONTESTANTS;
    address public WINNER;

    function Raffle(uint _maxTickets, uint _price) public onlyOwner {
        CREATOR = msg.sender;
        MAX_TICKETS = _maxTickets;
        PRICE = _price;
        uint qty = 1;
        Start(qty);
    }
  //use fallback function to send ether to the contract
    function () public payable {
        emit EventPaid(msg.sender, msg.value);
    }

    function Start(uint _qty) public onlyOwner returns(bool) {
        require(PRICE * _qty > msg.value);
        require(int(CONTESTANTS.length) < int(MAX_TICKETS - _qty));
        for (uint i = 0; i < _qty; i++) {
            CONTESTANTS.push(msg.sender);
        }
        emit EventJoin (CONTESTANTS.length, _qty);
        if (CONTESTANTS.length == MAX_TICKETS) {
            return Draw();
        }
        return true;
    }
  // award PRIZE when all tickets are sold
    function Draw() public onlyOwner returns (bool) {
        uint256 randomNumber = uint256(block.timestamp) % uint256( CONTESTANTS.length-1);
        WINNER = CONTESTANTS[randomNumber];
        PRIZE = address(this).balance; 
        payable(WINNER).transfer(PRIZE);
        emit EventDraw (address(WINNER), PRIZE);
        return true;
    }
}


