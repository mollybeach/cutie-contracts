contract ProjectDraca is ERC721Enumerable, Ownable {
  using Strings for uint256;

  string public baseURI;
  string public baseExtension = ".json";
  string public notRevealedUri;
  uint256 public cost = 88000000000000000;
  uint256 public maxSupply = 996;
  uint256 public maxMintAmount = 1;
  uint256 public nftPerAddressLimit = 4;
  bool public paused = true;
  bool public revealed = false;
  bool public onlyWhitelisted = true;
  address public feeCollector;
  address[] public whitelistedAddresses;
  mapping(address => uint256) public addressMintedBalance;
  mapping(uint256 => uint256) public idToValue;
  mapping(uint256 => bool) public usedValues;


  constructor(
    string memory _name,
    string memory _symbol,
    string memory _initNotRevealedUri,
    address _feeCollector
  ) ERC721(_name, _symbol) {
    setNotRevealedURI(_initNotRevealedUri);
    feeCollector = _feeCollector;  
  }

  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }
  
  // This returns a psudo random number, used in conjunction with the not revealed URI
  // it prevents all leaks and gaming of the system
  function random() public returns (uint256 _pRandom) {
    uint256 pRandom = (uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, totalSupply()))) % 997) + 1;
    for(uint256 i = 0; i <= 997; i++){
        if(!usedValues[pRandom]){
            usedValues[pRandom] = true;
            return pRandom;
        } else {
            pRandom--;
            if(pRandom == 0) {
                pRandom = 996;
            }
        }
    }
  }

  // public
  function mint(uint256 _mintAmount) public payable {
    require(!paused, "the contract is paused");
    uint256 supply = totalSupply();
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
    require(addressMintedBalance[msg.sender] + _mintAmount <= nftPerAddressLimit, "max total mint amount allowed exceeded");
    require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");

    if (msg.sender != owner()) {
        if(onlyWhitelisted == true) {
            require(isWhitelisted(msg.sender), "User is not whitelisted");
            require(addressMintedBalance[msg.sender] < 1, "Max NFT per address in whitelist period exceeded");
        }
        require(msg.value >= cost * _mintAmount, "insufficient funds");
    }

    for (uint256 i = 1; i <= _mintAmount; i++) {
      addressMintedBalance[msg.sender]++;
      idToValue[supply + i] = random();
      _safeMint(msg.sender, supply + i);
    }
  }
  
  function isWhitelisted(address _user) public view returns (bool) {
    for (uint i = 0; i < whitelistedAddresses.length; i++) {
      if (whitelistedAddresses[i] == _user) {
          return true;
      }
    }
    return false;
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

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    
    if(revealed == false) {
        return notRevealedUri;
    }

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, idToValue[tokenId].toString(), baseExtension))
        : "";
  }

  //only owner
  function reveal() public onlyOwner {
      revealed = true;
  }
  
  function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
    nftPerAddressLimit = _limit;
  }
  
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
    maxMintAmount = _newmaxMintAmount;
  }

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }
  
  function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
    notRevealedUri = _notRevealedURI;
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
  
  function mintLegends() public onlyOwner {
    uint256 supply = totalSupply();

    for (uint256 i = 0; i <= 3; i++) {
      addressMintedBalance[msg.sender]++;
      _safeMint(msg.sender, supply + i);
      maxSupply += 1;
    }
  }
  
  function setOnlyWhitelisted(bool _state) public onlyOwner {
    onlyWhitelisted = _state;
  }
  
  function whitelistUsers(address[] calldata _users) public onlyOwner {
    delete whitelistedAddresses;
    whitelistedAddresses = _users;
  }

  function withdraw() public payable onlyOwner {

    (bool os, ) = payable(feeCollector).call{value: address(this).balance}("");
    require(os);
  }
}