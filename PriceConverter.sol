// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// A library to convert ETH to USD using Chainlink price feeds
library PriceConverter {
    // Function to get the latest ETH price in USD from Chainlink price feed
    function getPrice() internal view returns (uint256) {
        // Sepolia ETH / USD Address
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (
            , // uint80 roundID
            int256 answer, 
            , // uint256 startedAt
            , // uint256 updatedAt
            // uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        
        // Check if the answer is valid
        require(answer > 0, "Invalid price feed answer");
        
        // ETH/USD rate in 18 digit
        return uint256(answer * 1e10);
    }

    // Function to convert ETH amount to USD amount
    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
