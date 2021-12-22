// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


/*
    - Burn a Serum to transform a Mutant Cat into a Cured Cat
    it'll be an erc 721 mint contract
    You’ll need IERC1155 for this
    It’s an open zeppelin contract
    They will burn the serum
    So u need to transfer it to 0 address when u mint
    And they need to transfer the mutantcat to the contract when minting
    Create a method that can withdraw the cats


    Breed a VX with two curedCats with Fish

    

*/

contract VX is ERC721Enumerable, Ownable , IERC721Receiver {
    using Strings for uint256;
    event MintVXEvent(address indexed sender, uint256 startWith);
    event TransferCuredCatEvent(address indexed from, address indexed to, uint256 indexed tokenId);
    event BurnFishEvent(address indexed owner, uint256 indexed tokenId);

    //uint256 supply counters 
    uint256 public VXTotal;

    //uint256
    uint256 public maxMintsPerWallet= 1;
    uint256 public FISH_COST = 1;
    uint256 public supplyVX = 999;
    uint256 public VXSupply = 999;
    uint256 public CURED_CATS_TOKEN_ID = 1; 
    uint256 public FISH_TOKEN_ID = 1;
    uint256[] VXLastBred = new uint256[](999);

    //addressses
    IERC721 public VXAddress;
    IERC721 public curedCatsAddress;
    IERC1155 public fishAddress;
    address public zeroAddress;
    address public contractAddress;

    //mappings
    mapping(address => uint256) public addressMintedBalance;
    mapping (uint256 => string) private _tokenURIs;
    
    //strings
    string public baseURI;
    
    //bool
    bool private started;

    //constructor args 
    constructor(
        string memory _name,
        string memory _symbol,
        string memory baseURI_
    ) ERC721(_name, _symbol) {
        baseURI = baseURI_;
        contractAddress = address(this);
        VXAddress = IERC721(contractAddress);
    }

   //Basic Functions 
    function _baseURI() internal view virtual override returns (string memory){
        return baseURI;
    }
    function setBaseURI(string memory _newURI) public onlyOwner {
        baseURI = _newURI;
    }
    function setAddresses(address _curedCatsAddress, address _fishAddress) public onlyOwner {
        curedCatsAddress = IERC721(_curedCatsAddress);
        fishAddress = IERC1155(_fishAddress);
    }

    //ERC271 
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "tokenId does not exist.");
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : ".json";
    }
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
            require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
            _tokenURIs[tokenId] = _tokenURI;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
    //setStart 
    function setStart() public onlyOwner  {
        started = true;
    }
    //Total Supply 
    function totalSupply() public view virtual override returns (uint256) {
        return VXTotal;
    }
    function getLastBredVX(uint256 tokenId) public view returns (uint256) {
        return VXLastBred[tokenId];
    }

        //Allows Public to breed VX with two curedCats tokens using Fish
    function breedVX(uint256[] calldata _tokenIds)  public {
        require(started, "not started");
        require(VXTotal + 2 <= VXSupply, "This mint would pass max VX supply");
        require(fishAddress.balanceOf(msg.sender, FISH_TOKEN_ID) > FISH_COST, "Insufficient value of FISH to breed a VX");
        require(curedCatsAddress.balanceOf(msg.sender) > 2, "Must be a holder 2 Curedcats Token to breed VX"); 
        require(curedCatsAddress.ownerOf(_tokenIds[0]) == _msgSender() && curedCatsAddress.ownerOf(_tokenIds[1]) == _msgSender(), "must be the owner of both cured cats to breed");
        fishAddress.safeTransferFrom(msg.sender, zeroAddress,FISH_TOKEN_ID,  FISH_TOKEN_ID, "0x0"); 
        emit BurnFishEvent(_msgSender(), FISH_TOKEN_ID);
        curedCatsAddress.safeTransferFrom(msg.sender, contractAddress, CURED_CATS_TOKEN_ID);
        emit TransferCuredCatEvent(msg.sender, contractAddress, CURED_CATS_TOKEN_ID);  
        _mint(_msgSender(), VXTotal++);
        addressMintedBalance[msg.sender] += 1;
        emit MintVXEvent(_msgSender(), VXTotal);
    }

    // Withdraw Cats
    function withdrawVX() external onlyOwner {
        supplyVX = VXAddress.balanceOf(address(this));
        VXAddress.transferFrom(address(this), msg.sender,supplyVX);
    }


}


