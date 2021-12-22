// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


/*
    Transform a Mutant Cat into a Cured Cat using Serum
    - Burn a Serum to transform a Mutant Cat into a Cured Cat
    it'll be an erc 721 mint contract
    You’ll need IERC1155 for this
    It’s an open zeppelin contract
    They will burn the serum
    So u need to transfer it to 0 address when u mint
    And they need to transfer the mutantcat to the contract when minting
    Create a method that can withdraw the cats
    

*/

contract CuredCats is ERC721Enumerable, Ownable , IERC721Receiver {
    using Strings for uint256;
    event BurnSerumEvent(address indexed owner, uint256 indexed tokenId);
    event TransferMutantCatEvent(address indexed from, address indexed to, uint256 indexed tokenId);
    event MintCuredCatEvent(address indexed sender, uint256 startWith);

    //uint256 supply counters 
    uint256 public curedCatTotal;

    //uint256
    uint256 public curedCatSupply = 999;
    uint256 public MUTANT_CATS_TOKEN_ID;
    uint256 public CURED_CATS_TOKEN_ID;
    uint256 public SERUM_TOKEN_ID = 1;
    uint256 public SERUM_COST = 1;

    //addressses
    IERC721 public curedCatsAddress;
    IERC721 public mutantCatsAddress;
    IERC1155 public serumAddress;
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
        curedCatsAddress = IERC721(contractAddress);
    }

   //Basic Functions 
    function _baseURI() internal view virtual override returns (string memory){
        return baseURI;
    }
    function setBaseURI(string memory _newURI) public onlyOwner {
        baseURI = _newURI;
    }
    function setAddresses(address _mutantCatsAddress, address _serumAddress) public onlyOwner {
        mutantCatsAddress = IERC721(_mutantCatsAddress);
        serumAddress = IERC1155(_serumAddress);
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
        return curedCatTotal;
    }

    //Allows Public transform MutantCats tokens into CuredCats tokens for the price of 1 Serum
    function transformCuredCat(uint256[] calldata _tokenIds)  public {
        uint256 QTY = _tokenIds.length;
        require(started, "not started");
        require(curedCatTotal + QTY <= curedCatSupply, "This mint would pass max CuredCats supply");
        require(serumAddress.balanceOf(msg.sender, SERUM_TOKEN_ID) >= SERUM_COST * QTY , "Insufficient value of serum to transform a curedCat");
        require(mutantCatsAddress.balanceOf(msg.sender) > QTY, "Must be a holder mutantCats Token to transform into each Curedcats");

       //transfrorm mutantCats into curedCats
        for (uint256 i = 0; i < QTY; i++) {
            //burn serum
            serumAddress.safeTransferFrom(msg.sender, zeroAddress, SERUM_TOKEN_ID,  1, ""); 
            emit BurnSerumEvent(_msgSender(), SERUM_TOKEN_ID);

            //transfer mutantCats
            MUTANT_CATS_TOKEN_ID = _tokenIds[i];
            mutantCatsAddress.safeTransferFrom(msg.sender, contractAddress, MUTANT_CATS_TOKEN_ID);
            emit TransferMutantCatEvent(msg.sender, contractAddress, MUTANT_CATS_TOKEN_ID); 

            //mint curedCats
            CURED_CATS_TOKEN_ID = curedCatTotal + 1;
            _mint(_msgSender(), curedCatTotal++);
            addressMintedBalance[msg.sender] += 1;
            emit MintCuredCatEvent(msg.sender, CURED_CATS_TOKEN_ID);
        }
    }

    // Withdraw Cured Cats
    function withdrawCuredCats() external onlyOwner {
        curedCatSupply = curedCatsAddress.balanceOf(address(this));
        curedCatsAddress.transferFrom(address(this), msg.sender, curedCatSupply);
    }


}


