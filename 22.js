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
  const arr1 = new Array;
  const arr2 = new Array;
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

const playGame = (arr1, arr2) => {
  let i = 0;
  while (arr1.length && arr2.length) {
    playOneRound(arr1, arr2, true);
    i++;
    console.log(
      `Turn ${i}. Player 1 has ${arr1}, Player 2 has ${arr2}`
    );
  }
  const winningSet = arr1.length ? arr1 : arr2;
  console.log(
    `Winner's score is: ${calculateWinningScore(Array.from(winningSet))}`
  );
  return winningSet;
};

const playOneRound = (arr1, arr2, recursive) => {
  const card1 = arr1.shift();
  const card2 = arr2.shift();
  if (recursive && card1 <= arr1.length && card2 <= arr2.length) {
    console.log("RECURSION");
    const arr1Recursive = arr1.slice(0, card1);
    const arr2Recursive = arr2.slice(0, card2);
    console.log(arr1Recursive);
    console.log(arr2Recursive);
    console.log(`Card 1 is ${card1} and card 2 is ${card2}`);
    const subGameWinner = playGame(arr1Recursive, arr2Recursive, true);
    console.log(`Card 1 is ${card1} and card 2 is ${card2}`);
    if (subGameWinner === arr1Recursive) {
      arr1.push(card1);
      arr1.push(card2);
    } else {
      arr2.push(card2);
      arr2.push(card1);
    }
  } else {
    if (card1 > card2) {
      arr1.push(card1);
      arr1.push(card2);
    } else {
      arr2.push(card2);
      arr2.push(card1);
    }
  }
};

populateArrays("./22-test.txt").then((res) => {
  playGame(res.arr1, res.arr2);
});
