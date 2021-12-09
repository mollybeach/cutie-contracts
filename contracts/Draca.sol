// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/*- Total supply: 5000
-
1 Genesis NFT in wallet = 1 free mint (996 Reserved Supply)
- Dev mint function that allows us to mint for free (300 Reserved Supply)
- Public mint 0.02 ETH mint price (3704 Supply)
- Would be good to let free mints and public at the same time (every mint after the allocated free mints per user would be 0.02eth, just like public
*/

contract Draca is ERC721Enumerable, Ownable {
    using Strings for uint256;
    event Mint(address indexed sender, uint256 startWith, uint256 times);

    //supply counters 
    uint256 public totalFreeMinted;
    uint256 public totalDevMinted;
    uint256 public totalPublicMinted;

    uint256 public freeMint = 996;
    uint256 public devMint = 300;
    uint256 public publicMint = 3704;

  //  uint256 public totalCount = 5000;
    //token Index tracker 
    uint256 public price = 20000000000000000; //0.02 ETH

    //string
    string public baseURI;

    //bool
    bool private started;

    //constructor args 
    constructor(string memory name_, string memory symbol_, string memory baseURI_) ERC721(name_, symbol_) {
        baseURI = baseURI_;
    }

    //basic functions. 
    function _baseURI() internal view virtual override returns (string memory){
        return baseURI;
    }
    function setBaseURI(string memory _newURI) public onlyOwner {
        baseURI = _newURI;
    }

    //erc721 
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
       // string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0
            ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '.json';
    }
    function setStart(bool _start) public onlyOwner returns (bool) {
        started = _start;
        return started;
    }

    function tokensOfOwner(address owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 count = balanceOf(owner);
        uint256[] memory ids = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            ids[i] = tokenOfOwnerByIndex(owner, i);
        }
        return ids;
    }

    //write function to check if the sender owns genesis token if it does it gets one free mint of draca
    function mintFree(uint256 _times, uint256 _tokenId) payable public {
        require(_exists(_tokenId), "User does not have a Genesis so cannot mint free.");
        require(started, "not started");
        require(totalFreeMinted + _times <= totalFreeMinted , "max supply reached!");
        emit Mint(_msgSender(), totalPublicMinted+1, _times);
        for(uint256 i=0; i< _times; i++){
            _mint(_msgSender(), 1 + totalPublicMinted++);
        }
    }  
     //write function to check if the sender owns genesis token if it does it gets one free mint of draca
    function mintDev(uint256 _times, uint256 _tokenId) payable public {
        require(_exists(_tokenId),  "User does not have a Genesis so cannot mint free.");
        require(started, "not started");
        require(totalDevMinted + _times <= totalDevMinted , "max supply reached!");
        emit Mint(_msgSender(), totalPublicMinted+1, _times);
        for(uint256 i=0; i< _times; i++){
            _mint(_msgSender(), 1 + totalPublicMinted++);
        }
    }

    //if the sender is the owner of the token it can be minted for fre
    function mintPublic(uint256 _times) payable public {
        require(started, "not started");
        require(totalPublicMinted + _times <= totalPublicMinted, "max supply reached!");
        require(msg.value == _times * price, "value error, please check price.");
        payable(owner()).transfer(msg.value);
        emit Mint(_msgSender(), totalPublicMinted+1, _times);
        for(uint256 i=0; i< _times; i++){
            _mint(_msgSender(), 1 + totalPublicMinted++);
        }
    }  
}