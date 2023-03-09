// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

// import the individual contracts
import "./PortfolioManager.sol";
import "./AssetExchange.sol";
import "./AssetManager.sol";

// Define the diamond contract
contract MyDiamond {
    // Use the Facet pattern to implement the functionality
    PortfolioManager public portfolioManager;
    AssetExchange public assetExchange;
    AssetManager public assetManager;

    constructor() {
        // initialize the individual contracts
        portfolioManager = new portfolioManager();
        assetExchange = new assetExchange();
        assetManager = new assetManager();
    }

    // forward the calls to the the appropriate contract
    fallback() {
        address facet = getAddress(msg.sig);
        require(facet !=(0), "Function does not exist");
        (bool succcess, bytes memory data) = facet.delegatecall(msg.sender);
        require(succcess, "Function call failed");
        assembly {
            return(add(data, 0x20), mload(data))
        }
    }

    // get the address of the approriate contract
    function getFacetAddress(bytes4 sig) private view returns (address) {
        bytes32 postion = keccak256(abi.encodepacked(sig, address(this)));
        address facet = address(bytes20(address(this) << 96 | uint96(postion)));
        if (facetAddress(facet) != address(0)) {
            return facet;
        }
        return address(0);
    }

    // utility function to check if a contract is present
    function facetAddress(address facet) private view returns (address) {
        if (facetAddress(facet) != address(0)) {
        return facet;
    }
    return address(0);
}
    }
