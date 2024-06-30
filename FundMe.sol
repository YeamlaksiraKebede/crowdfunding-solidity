// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();
error InsufficientFunds();

contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    address public immutable i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    bool public paused = false;

    event Funded(address indexed funder, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);
    event Paused();
    event Unpaused();

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

    modifier notPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable notPaused {
        if (msg.value.getConversionRate() < MINIMUM_USD) revert InsufficientFunds();
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        emit Funded(msg.sender, msg.value);
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    modifier reentrancyGuard() {
        uint256 _status = 1;
        require(_status != 2, "Reentrant call");
        _status = 2;
        _;
        _status = 1;
    }

    function withdraw() public onlyOwner reentrancyGuard {
        uint256 amount = address(this).balance;
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address ;
        (bool callSuccess, ) = payable(msg.sender).call{value: amount}("");
        require(callSuccess, "Call failed");
        emit Withdrawn(msg.sender, amount);
    }

    function pause() public onlyOwner {
        paused = true;
        emit Paused();
    }

    function unpause() public onlyOwner {
        paused = false;
        emit Unpaused();
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}
