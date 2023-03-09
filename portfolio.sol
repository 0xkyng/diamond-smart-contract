pragma solidity ^0.8.0;

// import ERC20 token contract
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PortfolioManager {

    // structure to hold investment information for each user
    struct Investment {
        uint amount;            // The amount invested
        uint startTime;         // The time the investment was made
        uint endTime;           // The time the investment matures
        uint returnPercentage;  // The percentage return on investment 
    }

    // Mapping user of address to their investments
    mapping (address => Investment) public investments;

    // THe total number of funds managed by the contract
    uint public totalFunds;

    // The ERC20 token used for investments
    IERC20 public investmentToken;

    constructor(address _investmentTokenAddress) {
        investmentToken = IERC20(_investmentTokenAddress);
    }

    // Invest a certain amount of tokens for a given duration
    function invest(uint amount, uint duration, uint returnPercentage) external {
        require(amount > 0, "Amount must be greater than 0");
        require(duration > 0, "Duration must be greater 0");

        // Transfer the investment tokens from the investor to the contract
        require(investmentToken.transfer(msg.sender, address(this), amount), "Token transfer failed");

        // Calculate the end time for the investment 
        uint endTime = block.timestamp + duration;

        // Store the investmnent information for the user
        investments[msg.sender] = Investment({
            amount: amount,
            startTime: block.timestamp,
            endTime: endTime,
            returnPercentage: returnPercentage
        });

        // Add the amount to the total funds managed by the contract
        totalFunds += amount;
    }

    // Withdraw the investment and return the generated returns
    function withdraw() external {
        Investment memory investment = investments[msg.sender];
        require(investment.amount > 0, "You have no investment");
        require(block.timestamp >= investment.endTime, "Investment is not mature yet");

        // Calculate the return on investments
        uint returns = investmnent.amount * investment.returnPercentage / 100;


        // Remove the investment information from the mapping
        delete investments[msg.sender];

        // Transfer the investment tokens and returns back to the investor
        require(investmentToken.transfer(msg.sender, investment.amount + returns), "Token transfer failed");

        // Subtract the amount invested from the total funds managed by the contract
         totalFunds -= investment.amount;
    }

    // Get the amount of tokens held by the contract
    function getContractBalance() external view returns (uint) {
        return investmentToken.balanceOf(address(this));
    }

    
}