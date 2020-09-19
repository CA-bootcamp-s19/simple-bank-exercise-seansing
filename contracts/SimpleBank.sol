/*
    This exercise has been updated to use Solidity version 0.6.12
    Breaking changes from 0.5 to 0.6 can be found here: 
    https://solidity.readthedocs.io/en/v0.6.12/060-breaking-changes.html
*/

pragma solidity ^0.5.0;

contract SimpleBank {
    //
    // State variables
    //

    /* DONE - Fill in the keyword. Hint: We want to protect our users balance from other contracts*/
    mapping(address => uint256) private balances;

    /* DONE - Fill in the keyword. We want to create a getter function and allow contracts to be able to see if a user is enrolled.  */
    mapping(address => bool) public enrolled;

    /* DONE - Let's make sure everyone knows who owns the bank. Use the appropriate keyword for this*/
    address public owner;

    //
    // Events - publicize actions to external listeners
    //

    /* DONE - Add an argument for this event, an accountAddress */
    event LogEnrolled(address accountAddress);

    /* DONE - Add 2 arguments for this event, an accountAddress and an amount */
    event LogDepositMade(address accountAddress, uint256 amount);

    /* DONE - Create an event called LogWithdrawal */
    /* DONE - Add 3 arguments for this event, an accountAddress, withdrawAmount and a newBalance */
    event LogWithdrawal(
        address accountAddress,
        uint256 withdrawAmount,
        uint256 newBalance
    );

    //
    // Functions
    //

    /* DONE - Use the appropriate global variable to get the sender of the transaction */
    constructor() public {
        /* Set the owner to the creator of this contract */
        owner = msg.sender;
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function() external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    // DONE - A SPECIAL KEYWORD prevents function from editing state variables;
    // allows function to run locally/off blockchain.
    function getBalance() public view returns (uint256) {
        /* Get the balance of the sender of this transaction */
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    // DONE - Emit the appropriate event
    function enroll() public returns (bool) {
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    // DONE - Add the appropriate keyword so that this function can receive ether
    // DONE - Use the appropriate global variables to get the transaction sender and value
    // DONE - Emit the appropriate event
    // DONE - Users should be enrolled before they can make deposits
    function deposit() public payable returns (uint256) {
        /* Add the amount to the user's balance, call the event associated with a deposit,
          then return the balance of the user */
        require(enrolled[msg.sender] == true);
        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    // Emit the appropriate event
    function withdraw(uint256 withdrawAmount) public returns (uint256) {
        /* DONE- If the sender's balance is at least the amount they want to withdraw,
           DONE - Subtract the amount from the sender's balance, 
           DONE -and try to send that amount of ether
           to the user attempting to withdraw. 
           return the user's balance.*/
        uint256 senderBalance = balances[msg.sender];
        if (senderBalance >= withdrawAmount) {
            uint256 newBalance = senderBalance - withdrawAmount;
            balances[msg.sender] = newBalance;
            msg.sender.transfer(withdrawAmount);
            emit LogWithdrawal(
                msg.sender,
                withdrawAmount,
                balances[msg.sender]
            );
            return balances[msg.sender];
        } else {
            revert();
        }
    }
}
