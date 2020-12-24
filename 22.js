// Begin with two arrays: one representing human's cards, one representing crab's cards
// Use Sets for better performance?
// Have a compare cards function that sends both cards to bottom of winner's pile
// Iterate until one player runs out of cards

const { getData } = require("./helpers");
const inspect = require('util').inspect;

const populateSets = async (fn) => {
  const decks = await getData(fn, "\n\n", false);
  player1 = decks[0]
    .split("\n")
    .slice(1)
    .map((str) => Number(str));
  player2 = decks[1]
    .split("\n")
    .slice(1)
    .map((str) => Number(str));
  set1 = new Set(); set2 = new Set();
  for (const card of player1) {
    set1.add(card);
  }
  for (const card of player2) {
    set2.add(card)
  }
  return {set1, set2}
};

const calculateWinningScore = (arr) => {
  return arr.reduce((acc, val, ind, arr) => acc + val * (arr.length - ind), 0);
};

const playGame = (set1, set2) => {
  let i = 0;
  while (set1.size && set2.size) {
    card1 = set1.values().next().value;
    card2 = set2.values().next().value;
    set1.delete(card1);
    set2.delete(card2);
    if (card1 > card2) {
      set1.add(card1);
      set1.add(card2);
    } else {
      set2.add(card2);
      set2.add(card1);
    }
    i++;
    console.log(`Turn ${i}. Player 1 has ${Array.from(set1)}, Player 2 has ${Array.from(set2)}`);
  }
  return set1.size ? calculateWinningScore(Array.from(set1)) : calculateWinningScore(Array.from(set2));
};

populateSets("./22-input.txt").then((res) => {
  console.log(`Winner's score is: ${playGame(res.set1, res.set2)}`);
});
