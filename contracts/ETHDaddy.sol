// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ETHDaddy is ERC721{

    uint256 public maxSupply;
    uint256 public totalSupply;
    address public owner;

    struct Domain {
        string name;
        uint256 cost;
        bool isOwned;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Can only be called by the owner");
        _;
    }

    mapping(uint256 => Domain) domains;

    //Constructor
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        owner = msg.sender;
    }

    //Function to list a domain NFT on the site
    function list(string memory _name, uint256 _cost) public onlyOwner{
        maxSupply++;
        domains[maxSupply] = Domain(_name, _cost, false);
    }

    //Fucntion to get the domains
    function getDomain(uint256 _id) public view returns (Domain memory) {
        return domains[_id];
    }

    //Function to mint domain NFTs, using the safeMint function from the ERC721 contract
    function mint(uint256 _id) public payable {
        require(_id != 0);
        require(_id <= maxSupply);
        require(domains[_id].isOwned == false);
        require(msg.value >= domains[_id].cost);

        domains[_id].isOwned = true;
        totalSupply++;
        _safeMint(msg.sender, _id);
    }

    //Function to get the balance of this contract
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }

    //Function for the contract owner to withdraw ETH from the contract
    function withdraw() public onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }

}
