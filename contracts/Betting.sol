pragma solidity ^0.5.0;
contract Betting {
    enum colorChoices {red, blue, green, yellow, purple, orange} // feel free to change the colors, it has no impact on the code at all.
    struct Bets {
        colorChoices colorSelected; 
        uint256 amountBet;
        address payable gambler;
    }
    mapping(bytes32 => Bets) public bets; // holds information associated with betIds
    bytes32[] betIds = new bytes32[](10); // holds all betIds
    uint256 poolAmount; // functionally identical to the contract's balance.
    uint256 startTime; // time that betting rounds starts
    uint256 endTime; // time it ends
    uint256 minimumBet; // minimum buyin
    uint256 winningColor; // holds winning color
    bool running; // whether or not there is a round currently ongoing
    address payable[]  players = new address payable[](10); // used to limit the amount of players (gas costs)

    
    event TimeOut(uint256 current_time); // have a listener that watches this event on javascript-side
    event Color(uint256 color); // event emitted when color is chosen
    
    constructor(uint256 _minimumBet) public {
        running = false; // shouldn't be started automatically
        minimumBet = _minimumBet;  // sets minimum bet
        betIds.length = 0; // zero betIds at start
    }
    
    function startBet(uint256 _endTime) public {
        // holds the start/end times and allows contract to start accepting transactions
        require(running == false, "can't start a bet that's already running");
        startTime = block.timestamp;
        endTime = block.timestamp + _endTime; // the round will end in "_endTime" seconds
        running = true;
        winningColor = uint(keccak256(abi.encodePacked(uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, blockhash(block.number)))) % 6)));
    }
    
    function currentTime() public view returns (int256){
        return int(endTime - block.timestamp); // holds time left in a bet
    }
    
    function checkTimeLeft() public returns (int256){ // emits an event if time is out
        int256 time = currentTime();
        if(time < 1){
            emit TimeOut(block.timestamp);
        }
        return time;
    }
    
    function makeBet(uint256 _colorSelected ) public payable returns(bytes32) {
        bool duplicate = false;
        uint256 amountOfPlayers = getPlayerAmount();
        require(msg.value >= minimumBet, "did not meet minimum buy-in");
        require(running, "the bet is currently not running");
        require(currentTime() > 0, "time has run out");
        
        bytes32 betId = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        for(uint256 i = 0; i < amountOfPlayers; i++){
            if(players[i] == msg.sender){
                duplicate = true;
            }
        }
        require(amountOfPlayers < 10 || duplicate, "only 10 players can play in a given round");
        
        // set betId, change pool amomunt, and add players to their array
        
        bets[betId].colorSelected = colorChoices(_colorSelected);
        bets[betId].amountBet = msg.value;
        bets[betId].gambler = msg.sender;
        betIds.push(betId);
        poolAmount = poolAmount + msg.value;
        if(!duplicate){
            players[amountOfPlayers] = msg.sender;
        }
    }
    
    
    function endBet() public {
        require(running==true, "you can't end a bet that isn't running");
        running = false; // stop accepting bets
        // get winning colorChoices
        winningColor = getWinningColor();
        require(winningColor != 6, "error in receiving the correct winningColor");
        address payable[] memory winners = getWinners(uint256(winningColor));
        uint256 index = 0;
        // gets how many winners there are
        for(uint256 i = 0; i < winners.length; i++){
            if(winners[i] == address(0)){
                index = i;
                break;
            }
        }
        if(index != 0){ // only distribute funds, clear pool if there's a winner.
            uint256 splitWinnings = poolAmount / index; // divide the pool by the amount of winners.
            for(uint256 i=0; i< index; i++){
                if(winners[i] != address(0)){ //another precaution to make sure no zero addresses are paid, probably redundant 
                    winners[i].transfer(splitWinnings);
                }
            }
            poolAmount = 0;
        }
        clearBetIds(); // clear bets regardless of outcome
        clearPlayerAddresses(); // clear player addresses and let other people play
        
    }
    function getWinners(uint256 _winningColor) public view returns (address payable[] memory) {
        address payable[] memory winners = new address payable[](10); // limit of 10 participants
        // because address payable[] must be memory
        uint256 index = 0;
        bool duplicate = false;
        for(uint256 i=0; i<betIds.length; i++) {
            if(bets[betIds[i]].colorSelected == colorChoices(_winningColor)){
                for(uint256 j = 0; j < index; j++){
                    if(bets[betIds[i]].gambler == winners[j]){
                        duplicate = true;
                    }
                }
                if(!duplicate){
                    winners[index] = bets[betIds[i]].gambler;
                    index = index + 1;
                    
                }
                duplicate = false;
            }
       }
       return winners;
    }
    // set everything to 0 when a round is finished
    function clearBetIds() public {
        betIds.length = 0;
    }  
    function clearPlayerAddresses() public {
        for(uint256 i = 0; i < 10; i++){
            players[i] = address(0);
        }
    }
   // basic global variables
   function getBetId() public view returns (bytes32) {
       return betIds[betIds.length -1]; // returns latest bet made
   }
   function getBetIdLength() public view returns (uint256){
        return betIds.length;
   }
   function getStartTime() public view returns (uint256){
        return startTime;
   }
   function getEndTime() public view returns (uint256){
        return endTime;
   }
   function getMinimumBet() public view returns (uint256){
        return minimumBet;
   }
   function getIsRunning() public view returns (bool){
        return running;
   }
   function getPoolAmount() public view returns (uint256){
    return poolAmount;
   }
   function getWinningColor() public view returns (uint256){
    if(winningColor == 18569430475105882587588266137607568536673111973893317399460219858819262702947) {
        return 0;
    }
    else if(winningColor == 80084422859880547211683076133703299733277748156566366325829078699459944778998) {
        return 1;
    }
    else if(winningColor ==29102676481673041902632991033461445430619272659676223336789171408008386403022) {
        return 2; 
    }
    else if(winningColor == 87903029871075914254377627908054574944891091886930582284385770809450030037083) {
        return 3;
    }
    else if(winningColor == 62514009886607029107290561805838585334079798074568712924583230797734656856475) {
        return 4;
    }
    else if(winningColor == 1546678032441257452667456735582814959992782782816731922691272282333561699760) {
        return 5;
    }
    else{
        return 6;
    }
   }
   // get specific info from betIds
   function getColorSelected(bytes32 id) public view returns (uint256){
        return uint(bets[id].colorSelected);
   }
   function getAmountBet(bytes32 id) public view returns (uint256){
        return bets[id].amountBet;
   }
   function getGambler(bytes32 id) public view returns (address payable){
        return bets[id].gambler;
   }
   function getPlayerAmount() public view returns (uint256){ // iterate until 10 or 0 address is found, whichever is first
        uint256 index = 0;
        while(players[index] != address(0)){
            index++;
            if(index==10){
                break;
            }
        }
       return index;
   }
}