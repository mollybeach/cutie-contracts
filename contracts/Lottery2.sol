// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "./StackedToadz.sol";

/* 
LOTTERY CONTRACT
GOALS: 
    Write a contract that enters users into a raffle from the Stacked Toadz contract.
INFO: 
    The owner must purchase the first ticket on creation,
    contestants can buy as many tickets as are available
    The prize is awarded to a random winner when the tickets are all sold out
*/

contract Lottery  {
    
    //events 
    event JoinEvent(uint256 _length, uint _qty);
    event DrawEvent(address winner);
    event ClaimEvent(address _winner, uint256 _prize);

    //uint256
    uint256 public MAX_TICKETS = 999;
    uint256 public PRIZE = 10000000000000000; // the prize is 0.1 ether
    uint256 public TICKETS; 

    //addresses
    address[] public TICKETBAG;
    address[] public EMPTY_TICKETBAG;
    address WINNER;

    //bools
    bool public LOTTO_LIVE;

    // mappings 
    mapping(address => uint256) public AMOUNT_MAPPING;

    //constructor
    constructor() public {
        TICKETS = 0;
        LOTTO_LIVE = false;
    }

    //functions
    function startLotto() public onlyOwner(){
        require(!LOTTO_LIVE);
        LOTTO_LIVE = true;
        TICKETS = 0;
        TICKETBAG = EMPTY_TICKETBAG;
        buyTickets(AMOUNT_MAPPING[msg.sender]);
    }

    //any who has stack will buy tickets
    function buyTickets(uint256 _qty) public view {
        require(LOTTO_LIVE = true);
        AMOUNT_MAPPING[msg.sender] = _qty;
        require(_qty > 0);
        require(TICKETBAG.length + _qty <= MAX_TICKETS);
        for (uint256 i = 0; i < _qty; i++) {
        TICKETBAG.push(msg.sender);
        }
        emit JoinEvent (TICKETBAG.length, _qty);
        if(TICKETBAG.length == MAX_TICKETS) {
            endLotto();
        }
    }

    //award prize when all tickets are sold endLotto
    function draw() public onlyOwner view returns(address){
        require(TICKETBAG.length == MAX_TICKETS);
        require(TICKETBAG.length > 0);
        require(LOTTO_LIVE);
        uint256 randomNum = uint256(block.timestamp) % uint256(TICKETBAG.length-1);
        WINNER = TICKETBAG[randomNum];
        emit DrawEvent(WINNER);
        return WINNER;
    }

 //pay out the winner and reset the lottery
    function endLotto() public onlyOwner payable {
        require(LOTTO_LIVE);
        WINNER = draw(TICKETBAG);
        payable(WINNER).transfer(PRIZE);
        emit ClaimEvent(WINNER, PRIZE);
        LOTTO_LIVE = false;
        TICKETBAG = EMPTY_TICKETBAG;
    }

}



    
