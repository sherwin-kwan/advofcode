// Begin with two arrays: one representing human's cards, one representing crab's cards
// Use Sets for better performance?
// Have a compare cards function that sends both cards to bottom of winner's pile
// Iterate until one player runs out of cards

// PART 2
// Begin with sets for human's and crab's cards
// Have a compare cards function with a twist: it also checks if both numbers are greater than the # of cards left in the player's deck
// The normal (compare cards and send both cards to bottom of winner's pile) rule applies if at least one player doesn't have the required # of cards
// If both players have at least as many cards as their top number, begin a sub-game; copy next N cards for both players and recurse
// Add a check for repetition of position and award a win to Player 1

const { getData } = require("./helpers");
const inspect = require("util").inspect;
const isEqual = require("lodash.isequal");

const populateArrays = async (fn) => {
  const decks = await getData(fn, "\n\n", false);
  player1 = decks[0]
    .split("\n")
    .slice(1)
    .map((str) => Number(str));
  player2 = decks[1]
    .split("\n")
    .slice(1)
    .map((str) => Number(str));
  const arr1 = new Array();
  const arr2 = new Array();
  for (const card of player1) {
    arr1.push(card);
  }
  for (const card of player2) {
    arr2.push(card);
  }
  return { arr1, arr2 };
};

const calculateWinningScore = (arr) => {
  return arr.reduce((acc, val, ind, arr) => acc + val * (arr.length - ind), 0);
};

const playGame = (arr1, arr2, recursive, previous, level) => {
  let i = 0;
  while (arr1.length && arr2.length) {
    playOneRound(arr1, arr2, recursive, level); // Check to make sure this isn't a repetition of position
    for (const previousPosition of previous) {
      if (isEqual(previousPosition, { arr1, arr2 })) {
        console.log(`Repetition of position. Player 1 wins ${level ? 'level ' + level + ' subgame' : 'main game'} after ${i} turns by default`);
        return "1";
      }
    }
    // If it's not repetition of positoin, copy the arrays and push them into the list of previous arrays
    previous.push({
      arr1: [...arr1],
      arr2: [...arr2],
    });
    i++;
    if (level === 0) console.log(`Turn ${i}, Level ${level}. Player 1 has ${arr1}, Player 2 has ${arr2}`);
  }
  const winningArr = arr1.length ? 'arr1' : 'arr2';
  if (level) {
    console.log(`Player ${winningArr.slice(3)} wins level ${level} subgame after ${i} turns`);
  } else {
    console.log(`Player ${winningArr.slice(3)} wins game after ${i} turns with a score of: ${calculateWinningScore(eval(winningArr))}`);
  };
  return winningArr.slice(3);
};

const playOneRound = (arr1, arr2, recursive, level) => {
  const card1 = arr1.shift();
  const card2 = arr2.shift();
  let subGameWinner = "";
  if (recursive && card1 <= arr1.length && card2 <= arr2.length) {
    const arr1Recursive = arr1.slice(0, card1);
    const arr2Recursive = arr2.slice(0, card2);
    const prevRecursive = new Array();
    subGameWinner = playGame(
      arr1Recursive,
      arr2Recursive,
      true,
      prevRecursive,
      level + 1
    );
  }
  if (subGameWinner === "1" || (!subGameWinner && card1 > card2)) {
    arr1.push(card1);
    arr1.push(card2);
  } else if (subGameWinner === "2" || (!subGameWinner && card2 > card1)) {
    arr2.push(card2);
    arr2.push(card1);
  } else {
    throw new Error('Something went wrong');
  }
};

populateArrays("./22-input.txt").then((res) => {
  const previous = new Array();
  playGame(res.arr1, res.arr2, false, previous, 0);
});// Player 1 wins game after 785 turns with a score of: 33561

populateArrays("./22-input.txt").then((res) => {
  const previous = new Array();
  playGame(res.arr1, res.arr2, true, previous, 0);
}); // Player 1 wins game after 979 turns with a score of: 34594
