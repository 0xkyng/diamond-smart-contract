pragma solidity ^0.8.0;
import "./ERC20.sol"; // import the ERC20 standard contarct
import "./ERC721.sol"; // import ERC721 standard contract

contract AssetManager {
    address public owner ; // address of the owner the contract

    // Array to store all the created ERC20 tokens created
    ERC20[] public erc20tokens;

    // Array to store created ERC721 tokens
    ERC721[] public erc721tokens;

    // events for creating a new token
    event NewERC20Token(address indexed tokenAddress, string name, string symbol);
    event NewERC721Token(address indexed tokenAdress, string name, string symbol);

    // constructor function to set the owner of the contract
    constructor() {
        owner = msg.sender;
    }

    // Function to create a new ERC721 token
    function createERC20Token(string memory name, string memory symbol, uint256 initialSupply) public {
        ERC20 newToken = new ERC20(name, symbol, initialSupply, msg.sender);
        erc20tokens.push(newToken);
        emit NewERC20Token(address(newToken), name, symbol);
    }

    // Function to create a new ERC20 token
        function createERC721Token(string memory name, string memory symbol) public {
        ERC721 newToken = new ERC721(name, symbol, msg.sender);
        erc721Tokens.push(newToken);
        emit NewERC721Token(address(newToken), name, symbol);
    }

    // Function to distribute ERC20 tokens to multiple addresses.
    function distributeERC20Tokens(address tokenAddress, address[] memory recipients, uint256[] memory amounts) public {
        require(msg.sender == owner, "only the owner can distribute tokens");
        ERC20 token = ERC20(tokenAddress);
        require(recipients.length == amounts.length, "Arrays lengths do not match");
        for (uint i = 0; i < recipients.length; i++) {
            token.transfer(recipients[i], amounts);
        }

    }

    // Function to distribute ERC721 tokens to multiple addresses
    function distributeERC721Tokens(address tokenAddress, address[] memory recipients, uint256[] memory tokenIds) public {
        require(msg.sender == owner, "Only te owner can disribute tokens");
        ERC721 token = ERC721(tokenAddress);
        require(recipients.length == tokenIds.length, "Arrays lengths do not match");
        for (uint i = 0; i < recipients; i++) {
            token.safeTransferFrom(msg.sender, recipients[i], tokenIds[i]);
        }

    }
}

