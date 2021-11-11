pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Enumerable";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract HeavenOrHell is Ownable, ERC721Enumerable {
    //berries token address
    address public berriesAddress;

    //uints
    //angel Supply 
    uint256 public angelSupply = 1000;
    //angel total supply
    uint256 public angelTotalSupply;
    //witch supply
    uint256 public witchSupply = 8000;
    //witch total supply
    uint256 public witchTotalSupply;
    //current supply 
    uint256 public totalBears;
    //roll price 
    uint256 public berriesCost = 50000000000000000000; 

    //bool
    bool private started;

    //string 
    string public baseURI;

    //constructor args 
    constructor(string memory name_, string memory symbol_, string memory _baseURI) ERC721(name_, symbol_) {
        baseURI = _baseURI; 
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function roll() internal pure returns (uint256) {
        uint256 rand = random(block.timestamp) % 10;
        if (rand == 1) {
            return 0;
        }
        if (rand == 2) {
            return 1;
        }
        if (rand > 2 && rand <= 10) {
            return 2;
        }
    }

    function mintBear(uint256 amount) public returns (string memory) {
        require(amount >= berriesCost, "need more berries");
        require(started, "not started");
        require(totalBears < 9000, "too many bears");
        uint256 rollOutcome = roll();
        if (rollOutcome == 0) {
            return "sorry!";
        }
        if (rollOutcome == 1 && angelTotalSupply < 1000) {
            _mint(_msgSender(), 1 + totalBears++);
            angelTotalSupply++;
            return "Heaven";
        }
        if (rollOutcome == 1 && angelTotalSupply == 1000) {
            return "sorry!";
        }
        if (rollOutcome == 2 && witchTotalSupply < 8000) {
            _mint(_msgSender(), 1 + angelSupply + totalBears++);
            return "Hell";
        }
        if (rollOutcome == 2 && witchTotalSupply == 8000) {
            return "sorry!";
        }
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
    function totalSupply() public view virtual returns (uint256) {
        return totalBears;
    }
    function _baseURI() internal view virtual override returns (string memory){
        return baseURI;
    }
    function setBaseURI(string memory _newURI) public onlyOwner {
        baseURI = _newURI;
    }
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
        
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0
            ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '.json';
    }
    function setTokenURI(uint256 _tokenId, string memory _tokenURI) public onlyOwner {
        _setTokenURI(_tokenId, _tokenURI);
    }
    function setStart(bool _start) public onlyOwner {
        started = _start;
    }
}