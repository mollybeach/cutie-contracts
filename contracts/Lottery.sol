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

    StackedToadz public contestants;
    event DrawRaffle(address winner, uint256 prize);

    //uints 
    uint256 public PRIZE = 10000000000000000; // the prize is 0.1 ether
    address[] public TICKETPOOL;
    address WINNER;

    //constructor
    constructor(address _players) {
        contestants = StackedToadz(_players);
    }
    //get the purchased tickets balance of the contestants
    function purchasedTicketsCount(address _player) public view returns (uint256) {
        return contestants.balanceOf(_player);
    }
    //enter a new player into the lottery x times (balance of the player in the StackedToadz contract)
    function newPlayer(address _player) public onlyOwner returns (address[] memory) {
        for (uint i = 0; i < purchasedTicketsCount(_player); i++) {
            TICKETPOOL.push(_player);
        }
        return TICKETPOOL;
    }
    //create a raffle call each newPlayer function for each address in contestants (StackedToadz)
    function createRaffle(address[] memory _contestants) public onlyOwner returns (address[] memory) {
        for (uint i = 0; i < _contestants.length; i++) {
            newPlayer(_contestants[i]);
        }
        return TICKETPOOL;
    }
    //draw the raffle and return the winner
    function drawRaffle(address[] memory _ticketpool) public onlyOwner returns (address) {
       // require(started);
        require(_ticketpool.length > 0);
        address[] memory RAFFLE = createRaffle(_ticketpool);
        uint256 randomNumber = uint256(block.timestamp) % uint256(TICKETPOOL.length-1);
        WINNER = RAFFLE[randomNumber];
        return WINNER;
    }
    // send prize to winner 
    function givePrize(address[] memory _contestants) public onlyOwner  {
        WINNER = drawRaffle(_contestants);
        payable(WINNER).transfer(PRIZE);
        emit DrawRaffle(WINNER, PRIZE);
    }
}