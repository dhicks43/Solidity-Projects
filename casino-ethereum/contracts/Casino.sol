pragma solidity 0.4.20;

contract Casino {
	address public owner;
	unit256 public minimumBet;
	unit256 public totalBet;
	unit256 public numberOfBets;
	unit256 public maxAmountOfBets = 100;
	address[] public players;

	struct Player {
		unit256 amountBet;
		unit256 numberSelected;

	}
	// ----------
	// The address of the player goes into playerInfo struct
	// ----------
	mapping(address => Player) public playerInfo

	// ----------
	// Anonymous function that captures mistakenly sent ether
	// ----------
	function() public payable {}

	// ----------
	// Constructor Function
	// The user address that created the contract is the owner
	// ----------
	function Casion(uint256 _minimumBet) public { 
		owner = msg.sender;
		if(_minimumBet != 0) minimumBet = _minimumBet;

	}

	// ----------
	// Used to destroy the contract whenver you want
	// Only the owner can kill it
	// ----------
	function kill() public {
		if(msg.sender == owner) selfdestruct(owner);

	}


	// ----------
	// Function to check if a player exists
	// 'constant' means the function doesn't cost any gas to run,
	// 		meaning it's already on the blockchain. Free as in beer
	// ----------
	function checkPlayerExists(address player) public constant returns(bool){
		for(uint256 i = 0; i < players.length; i++){
			if(players[i] == player) return true;
		}
		return false

	}


	// ----------
	// Generates a number between 1 and 10 that will be a winner
	// ----------
	function generateNumberWinner() public {
		uint256 numberGenerated = block.number % 10 + 1 // Incredibly insecure
		distributePrices(numberGenerated);
	}


	// ----------
	// Sends the corresponding ether to each winner depending on bets
	// 'memory' tag creates a fixed memory array
	// ----------
	function distributePrices(uint256 numberWinner) public {
		address[100] memory winners;
		uint256 count = 0;

		for(uint256 i = 0; i < players.length; i++){
			address playerAddress = players[i];
			if(playerInfo[playerAddress].numberSelected == numberWinner){
				winners[count] = playerAddress;
				count++

			}

			delete playerInfo[playerAddress]; // Delete the playerInfo array

		}

		players.length = 0 // Removes the players array from memory

		uint256 winnerEtherAmount = totalBet / winners.length;

		for(uint256 j = 0; j < count; j++){
			if(winners[j] != address(0)) winners[j].transfwe(winnerEtherAmount);

		} 
	}


	// ----------
	// Function that allows a user to bet between 1 and 10 inclusively
	// "payable" is a modifier
	// "require()" is a function that behaves like an if statement
	// ----------
	function bet(uint256 numberSelected) public payable { 
		require(!checkPlayerExists(msg.sender));
		require(numberSelected >= 1 && numberSelected <= 10);
		require(msg.value >= minimumBet);

		playerInfo[msg.sender].amountBet = msg.value;
		playerInfo[msg.sender].numberSelected = numberSelected;

		numberOfBets++;

		players.push(msg.sender);
		toalBet += msg.value;

		if(numberOfBets >= maxAmountOfBets) generateNumberWinner();
	}

}


