// Have a counter variable which starts at 0
// Iterate through the input array, reading one line at a time
// For each line, check if the condition is met
// If true, increment counter by 1. If false, leave counter as is.
// Return counter when the file read is finished.

const { readFile } = require("fs").promises;

async function getData(fn) {
  const contents = await readFile(fn, "utf-8");
  const arr = contents.split("\n");
  return arr;
}

const findPasswords = async (fn, isNewPolicy) => {
  const arr = await getData(fn);
  let counter = 0;
  arr.forEach((str) => {
    // Iterate through passwords and find out how many are qualified
    if (isPasswordQualified(str, isNewPolicy)) counter++;
  });
  console.log(`${counter} valid passwords found`);
};

const isPasswordQualified = (str, isNewPolicy) => {
  if (!str || typeof str != 'string') return false; // Just in case an undefined, null, or non-string value is entered
  // Split string into component parts: the first number (min), the second number (max), the character being searched for (myChar), and the password string
  const getMin = str.split("-");
  const min = getMin[0];
  const getMax = getMin[1].split(" ");
  const max = getMax[0];
  const getChar = getMax[1].split(":");
  const myChar = getChar[0];
  const password = getMax[2].trim();
  let counter = 0;
  if (isNewPolicy) {
    // New policy: "2-8 f [string]" means "if either character 2 or character 8, but not both, with one-based indexing, is f, the password passes"
    return (password[min - 1] === myChar) ^ (password[max-1] === myChar)
  } else {
    // Old policy: "2-8 f [string]" means "find whether there are between 2 and 8, inclusive, occurrences of the letter f in the string"
    for (const char of password) {
      if (char === myChar) counter++;
      if (counter > max) {
        return false;
      }
    }
    if (counter < min) {
      return false;
    }
    return true;
  }
};

findPasswords("./02-input.txt", false);
// Output: 655 valid passwords found

findPasswords("./02-input.txt", true);
// Output: 673 valid passwords found

// console.log(isPasswordQualified("6-9 b: nbvrbptfbbnbxb"));
