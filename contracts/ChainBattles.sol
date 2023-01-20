// SPDX-License-Identifier: MIT

// Deployed to Mumbai at: 0xA2d946c1E8317085AAFb21c109dd58D20c802750

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";


contract ChainBattles is ERC721URIStorage {
  using Strings for uint256;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // Keep track of the stats for each of the NFTs
  struct Stats {
    string class;
    uint256 level;
    uint256 health;
    uint256 attack;
    uint256 defense;
    uint256 speed;
    uint256 rarity;
  }

  mapping(uint256 => Stats) public tokenIdToStats;

  constructor() ERC721("Chain Battles", "CB") {
    
  }

  // Generates the NFT character SVG image
  function generateCharacter(uint256 _tokenId) public view returns (string memory) {
    string memory class = tokenIdToStats[_tokenId].class;
    string memory warriorColor = "#b71717";
    string memory mageColor = "#1660e0";
    string memory nftColor;

    if (keccak256(abi.encodePacked(class)) == keccak256("Warrior")) {
      nftColor = warriorColor;
    } else if (keccak256(abi.encodePacked(class)) == keccak256("Mage")) {
      nftColor = mageColor;
    }
    console.log("NFT Class: ", class); 
    console.log("NFT Color: ", nftColor);

    bytes memory svg = abi.encodePacked(
      '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
      '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
      '<rect width="100%" height="100%" fill=','"',nftColor,'"', '/>',
      '<text x="50%" y="20%" class="base" dominant-baseline="middle" text-anchor="middle">','"',class,'"',' #',_tokenId.toString(),'</text>',
      getStats(_tokenId),
      '</svg>'
    );

    return string(
      abi.encodePacked(
        "data:image/svg+xml;base64,",
        Base64.encode(svg)
      )
    );
  }

  // Gets the stats of the character
  function getStats(uint256 _tokenId) public view returns (string memory) {
    uint256 level = tokenIdToStats[_tokenId].level;
    uint256 health = tokenIdToStats[_tokenId].health;
    uint256 attack = tokenIdToStats[_tokenId].attack;
    uint256 defense = tokenIdToStats[_tokenId].defense;
    uint256 speed = tokenIdToStats[_tokenId].speed;
    uint256 rarity = tokenIdToStats[_tokenId].rarity;

    return string(
      abi.encodePacked(
        '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ",level.toString(),'</text>',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Health: ",health.toString(),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Attack: ",attack.toString(),'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Defense: ",defense.toString(),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",speed.toString(),'</text>',
        '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Rarity: ",rarity.toString(),'</text>'
      )
    );
  }

  // Generates the NFT character data URI from the JSON metadata
  function getTokenURI(uint256 _tokenId) public view returns (string memory){
    bytes memory dataURI = abi.encodePacked(
      '{',
        '"name": "Chain Battles #', _tokenId.toString(), '",',
        '"description": "Chain Battles is an NFT Game where you can own a Warrior or Mage character and train them to increase their Stats",',
        '"image": "', generateCharacter(_tokenId), '"',
      '}'
    );

    return string(
      abi.encodePacked(
        "data:application/json;base64,",
        Base64.encode(dataURI)
      )
    );
  }

  // Mints the Warrior character
  function mintWarrior() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    console.log("Minted token number: ", newItemId);

    // Initialize the stats
    tokenIdToStats[newItemId].class = "Warrior";
    tokenIdToStats[newItemId].level = 1;
    tokenIdToStats[newItemId].health = 100;
    tokenIdToStats[newItemId].attack = 10;
    tokenIdToStats[newItemId].defense = 10;
    tokenIdToStats[newItemId].speed = 10;
    tokenIdToStats[newItemId].rarity = randomNumber(100);

    // Sets the token URI
    _setTokenURI(newItemId, getTokenURI(newItemId));
    console.log("Token URI: ", getTokenURI(newItemId));
  }

  // Mint the Mage character
  function mintMage() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    console.log("Minted token number: ", newItemId);

    // Initialize the stats
    tokenIdToStats[newItemId].class = "Mage";
    tokenIdToStats[newItemId].level = 1;
    tokenIdToStats[newItemId].health = 100;
    tokenIdToStats[newItemId].attack = 10;
    tokenIdToStats[newItemId].defense = 10;
    tokenIdToStats[newItemId].speed = 10;
    tokenIdToStats[newItemId].rarity = randomNumber(100);

    // Sets the token URI
    _setTokenURI(newItemId, getTokenURI(newItemId));
    console.log("Token URI: ", getTokenURI(newItemId));
  }

  // Train the Character to increase its stats
  function train(uint256 _tokenId) public {
    require(_exists(_tokenId), "Token does not exist");
    require(ownerOf(_tokenId) == msg.sender, "You must own this NFT to train it!");

    // Increase the level by 1
    uint256 currentLevel = tokenIdToStats[_tokenId].level;
    tokenIdToStats[_tokenId].level = currentLevel + 1;
    console.log("Level: ", tokenIdToStats[_tokenId].level);

    // Increase the stats by a random number
    tokenIdToStats[_tokenId].health = tokenIdToStats[_tokenId].health + randomNumber(100);
    tokenIdToStats[_tokenId].attack = tokenIdToStats[_tokenId].attack + randomNumber(10);
    tokenIdToStats[_tokenId].defense = tokenIdToStats[_tokenId].defense + randomNumber(5);
    tokenIdToStats[_tokenId].speed = tokenIdToStats[_tokenId].speed + randomNumber(3);

    // Sets the new token URI
    _setTokenURI(_tokenId, getTokenURI(_tokenId));
    console.log("Token URI: ", getTokenURI(_tokenId));
  }

  // Generates a random number between 0 and _number param
  function randomNumber(uint256 _number) private view returns (uint256) {
    return uint256(
      keccak256(
        abi.encodePacked(
          block.timestamp,
          block.difficulty,
          msg.sender,
          _number
        )
      )
    ) % _number;
  }

}