pragma solidity ^0.5.0;

import "./manateeTOKEN.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract ManateeCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale, RefundablePostDeliveryCrowdsale  {
    // @TODO: Fill in the constructor parameters!
    constructor(
        uint rate,
        address payable wallet,
        ManateeCoin token, 
        uint open_time,
        uint close_time,
        uint goal
    )
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        Crowdsale(rate, wallet, token)
        TimedCrowdsale(open_time, close_time)
        CappedCrowdsale(goal)
        RefundableCrowdsale(goal)
        RefundablePostDeliveryCrowdsale()
        public
    {
        // constructor can stay empty
    }
}

contract ManateeCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;
    uint open_time;
    uint close_time;
    uint goal=2000000;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet // this address will receive all Ether raised by the sale
    )
        public
    {
        // create the Manatee token and keep its address handy
        ManateeCoin token = new ManateelCoin(name, symbol, 18);
        token_address = address(token);
        
        open_time=now;
        close_time=open_time+24 weeks;

        // create the ManateeCoinSale and tell it about the token
        ManateeCoinSale token_sale = new ManateeCoinSale(1, wallet, token, open_time, close_time, goal);
        // ManateeCoinSale token_sale = new ManateeCoinSale(1, wallet, token, goal);
        token_sale_address = address(token_sale);

        // make the ManateeCoinSale contract a minter, then have the ManateeCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
