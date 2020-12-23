// Create a "sillymath" function
// Recognize brackets with a regex and execute what's inside a bracket as a block
// Once blocks are solved, execute from left to right
// PART 2: Consider all additions a block, use a regex to pull them out and execute them, and then execute the multiplications

const { getData } = require('./helpers');

const solve = async (fn, part2) => {
  const rawData = await getData(fn, '\n', false);
  const evalFunction = part2 ? addFirstMath : sillyMath;
  const solutionArray = rawData.map(str => Number(bracketedSillyMath(str, evalFunction)));
  console.log(solutionArray);
  const solution = solutionArray.reduce((acc, val) => acc + val);
  console.log(`The sum is ${solution}`);
}

const bracketedSillyMath = (input, evalFunction) => {
  // Recursive case
  if (input.includes('(')) {
    executeBrackets = input.replace(/\([^()]+\)/g, match => evalFunction(match.slice(1, match.length - 1)));
    return bracketedSillyMath(executeBrackets, evalFunction);
  } else {
    // Base case
    return evalFunction(input);
  }
};

// Not going to bother checking for type. Assumes you'll get 1 + 2 * 3 + 4 * 5 ... formatted input. Just execute left to right, no operator precedence
const sillyMath = (input) => {
  const sillyArray = input.split(' ');
  if (sillyArray.length === 1) {
    return input
  } else if (sillyArray.length === 3) {
    return eval(input)
  } else {
    firstExpression = sillyArray.splice(0, 3);
    sillyArray.unshift(eval(firstExpression.join(' ')));
    return sillyMath(sillyArray.join(' '));
  }
};

const addFirstMath = (input) => {
  // Recursive case
  if (input.includes('+')) {
    executeAdditions = input.replace(/[\d]+\s\+\s[\d]+/g, match => sillyMath(match));
    return addFirstMath(executeAdditions);
  } else {
  // Base case
    return sillyMath(input);
  }
};

console.log(addFirstMath('2 * 3 + 20 + 1'));

solve('./18-input.txt', false); // Output: The sum is 280014646144
solve('./18-input.txt', true); // Output: The sum is 9966990988262