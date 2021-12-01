const { getData } = require("./helpers");

// Split into strings by groups (don't have to remove the newlines between people, just double-newlines between groups)
// Within each group, look for an occurrence of all the letters from A to Z. Increment counter each time a letter is located
// After iterating through the alphabet, push the final value of the counter to an array
// Sum the array to get the final count

// Warning: Have to remove the end-of-file newline from 06-input.txt to make this work

const alphabet = "abcdefghijklmnopqrstuvwxyz".split("");

async function getCountArray() {
  const data = await getData("06-input.txt", "\n\n", false);
  const countArray = data.map((group) => {
    let counter = 0;
    for (const letter of alphabet) {
      if (group.indexOf(letter) >= 0) counter++;
    }
    return counter;
  });
  return countArray;
}

const countEveryonesAnswers = (group) => {
  const splitGroup = group.split("\n");
  // Sort by shortest to longest string of "yes" answers
  splitGroup.sort((a, b) => (a.length < b.length ? -1 : 1));
  // Only have to check the letters in the shortest string
  const lettersToCheck = splitGroup[0].split("");
  let results = new Array();
  outerLoop:
  for (const letter of lettersToCheck) {
    for (let i = 1; i < splitGroup.length; i++) {
      if (!splitGroup[i].includes(letter)) {
        continue outerLoop; // Skip to next letter
      }
    }
    results.push(letter);
  }
  return results.length;
};

async function getCountArray2() {
  const data = await getData("06-input.txt", "\n\n", false);
  return data.map(countEveryonesAnswers);
}

async function getSum(func) {
  const countArray = await func();
  console.log(`The sum is ${countArray.reduce((acc, val) => acc + val)}`);
}

getSum(getCountArray);
// Output: The sum is 6542
getSum(getCountArray2);
// Output: The sum is 3299
