// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/*- Total supply: 5000

1 Genesis NFT in wallet = 1 free mint (996 Reserved Supply)
- Dev mint function that allows us to mint for free (300 Reserved Supply)
- Public mint 0.02 ETH mint PRICE (3704 Supply)
- Would be good to let free mints and public at the same time (every mint after the allocated free mints per user would be 0.02eth, just like public
*/

contract Draca is ERC721Enumerable, Ownable {
    using Strings for uint256;

    event Mint(address indexed sender, uint256 startWith, uint256 times);

    //supply counters 
    uint256 public freeTotal;
    uint256 public devTotal;
    uint256 public publicTotal;
    uint256 public totalMinted;
    
    uint256 public PRICE = 20000000000000000; //0.02 ETH
    uint256 public freeSupply = 996;
    uint256 public devSupply = 300;
    uint256 public publicSupply = 3704;
    IERC20 public stackAddress;

    //string
    string public baseURI;

    //bool
    bool private started;

    //constructor args 
    constructor(
        string memory name_, 
        string memory symbol_,
        address _stackAddress) 
        ERC721(name_, symbol_) {
        //baseURI = baseURI_;
        stackAddress = IERC20(_stackAddress);
    }

    //basic functions. 
    function _baseURI() internal view virtual override returns (string memory){
        return baseURI;
    }
    function setBaseURI(string memory _newURI) public onlyOwner {
        baseURI = _newURI;
    }

    //ERC271 
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
        //string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0
            ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '.json';
    }
    //setStart 
    function setStart(bool _start) public onlyOwner returns (bool) {
        started = _start;
        return started;
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
        tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
        return tokenIds;
    } 

    // public
    function mint(uint256 _times) payable public{

        require(started, "not started");
        require(_times > 0, "need to mint at least 1 NFT");
        
         //allow developer to mint 300 tokens for free
        if(owner() == _msgSender() && devTotal + _times <= devSupply){
            for(uint256 i=0; i< _times; i++){
            _mint(_msgSender(), 1 + devTotal++);
            }
        //allows public to mint 996 draca tokens for free if they are holders of Genesis token  
        } else if(balanceOf(_msgSender()) > 0 && walletOfOwner(_msgSender()).length < 1 && freeTotal + _times <= freeSupply ){ // "User has already minted thier one free Draca token");
            for(uint256 i=0; i< _times; i++){
            _mint(_msgSender(), 1 + freeTotal++);
            }
        //allows public to mint 3704 tokens of Draca for 0.2Eth
        } else {
            require(publicTotal + _times <= publicSupply, "max supply reached!");
            require(msg.value == _times * PRICE, "insufficient funds");
            payable(owner()).transfer(msg.value);
            for(uint256 i=0; i< _times; i++){
            _mint(_msgSender(), 1 + publicTotal++);
        }

        emit Mint(_msgSender(), totalMinted+1, _times);
        
        }
    }


}

