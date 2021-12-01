// STEP 1: PARSE THE FILE
// Create an array of objects {operation, value}
//
// STEP 2: CREATE A SEQUENCE OF INSTRUCTIONS
// [0, 1, 2, 6, 7. 2, 3 ..., ] jumping around whenever jump is encountered, and skipping when nop is encountered
// Continue looping until a number is repeated or the end of the program is reached. This generates a full sequence of indexes to do.
// Map indexes back into "values to accumulate". (There should only be acc operations in the array)
//
// STEP 3: ADD
// Use a reducer function to sum the array
//
// STEP 4: ATTEMPT FIX
// Iterate through the list of instructions
// If the instruction is a NOP or JMP, create a new instruction array with only that instruction replaced NOP -> JMP or JMP -> NOP
// Run the sequence function again. If the program terminates, continue on to the reducer function to get the solution.
// If the program does not terminate, continue to next instruction
//
// Warning: Ending newline removed from 08-input.txt to make the file parse correctly

const { getData } = require("./helpers");

async function parseFile(fn) {
  const data = await getData(fn, "\n", false);
  return data.map((instruction) => {
    const operation = instruction.slice(0, 3);
    const value = Number(instruction.slice(3));
    return { operation, value };
  });
}

const makeAccumulatorSequence = (instructions) => {
  const sequence = new Array();
  let success = null;
  let i = 0;
  while (true) {
    if (sequence.includes(i)) {
      success = false;
      break;
    } else if (i === instructions.length) {
      // "Attempting to execute an instruction immediately after the final instruction"
      success = true;
      break;
    }
    if (instructions[i].operation === "acc") {
      sequence.push(i);
      i++;
    } else if (instructions[i].operation === "jmp") {
      // "JMP 0" causes an infinite loop on itself
      if (instructions[i].value === 0) {
        success = false;
        break;
      }
      i += instructions[i].value;
    } else if (instructions[i].operation === "nop") {
      i++;
    } else {
      console.log(`Error at ${i}`, instructions.length);
      throw new Error(`Unknown operation ${instructions[i].operation}`);
    }
  }
  return [sequence.map((ind) => instructions[ind].value), success];
};

const repairBootSequence = (instructions) => {
  let tryInstructions = [];
  for (let i = 0; i < instructions.length; i++) {
    if (instructions[i].operation === "jmp") {
      tryInstructions = instructions.slice();
      tryInstructions[i].operation = "nop";
      const isThisFixed = makeAccumulatorSequence(tryInstructions);
      if (isThisFixed[1]) {
        console.log(
          `At index ${i}, toggling an operation makes the program terminate!`
        );
        return isThisFixed;
      }
      // If failed, change the operation back to the original one
      tryInstructions[i].operation = "jmp";
    } else if (instructions[i].operation === "nop") {
      tryInstructions = instructions.slice();
      tryInstructions[i].operation = "jmp";
      const isThisFixed = makeAccumulatorSequence(tryInstructions);
      if (isThisFixed[1]) {
        console.log(
          `At index ${i}, toggling an operation makes the program terminate!`
        );
        return isThisFixed;
      }
      // If failed, change the operation back to the original one
      tryInstructions[i].operation = "nop";
    }
  };
};

async function findSum(fn) {
  const instructionArray = await parseFile(fn);
  const sequence = makeAccumulatorSequence(instructionArray);
  if (sequence[1]) {
    console.log(
      `When the program terminates, the accumulator is ${sequence[0].reduce(
        (acc, val) => acc + val
      )}`
    );
  } else {
    console.log(
      `Before the infinite loop begins, the accumulator is ${sequence[0].reduce(
        (acc, val) => acc + val
      )}`
    );
  }
  const fixedSequence = repairBootSequence(instructionArray);
  console.log(
    `When the program terminates, the accumulator is ${fixedSequence[0].reduce(
      (acc, val) => acc + val
    )}`)
}

findSum("./08-test.txt");
findSum("./08-input.txt"); 
// Output: Before the infinite loop begins, the accumulator is 1586
// At index 174, toggling an operation makes the program terminate!
// When the program terminates, the accumulator is 703
