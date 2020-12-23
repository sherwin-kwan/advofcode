const { getData } = require("./helpers");
const { IntervalTree } = require("node-interval-tree");
const intervalTree = new IntervalTree();
const { writeFile } = require("fs").promises;

// PARSING THE FILE
// Use double-newline to split off the first section, which deals with attributes and allowable ranges
// Save "your ticket" as entry 0 in an array of tickets, and all the other tickets should be pushed thereafter
// Iterate through the allowable ranges, adding them into an Interval Tree of allowable integers for that attribute
// Iterate through the list of tickets, for each ticket identify any numbers which belong to zero intervals and push them to an array of "invalid" numbers
// Use reducer to sum invalid numbers

// PART 2:
// Create a new array with "valid" tickets only, removing any ticket which has so much as a single invalid number for any attribute
// Create a number of new arrays, mapping all the numbers at index 0 on every ticket into one array; repeating for index 1, 2, 3, ...
// Sort each mapped array
// Iterate through each mapped array, comparing it to a list of "gap" intervals for each attribute
// Create new object to hold clues
// If a value is found in one of the arrays which falls into a gap, push the name of that attribute as an "eliminated" attribute in clues
// Loop through the attributes, for each attribute loop through the position clues, and find positions that potentially could be the attribute (i.e. have not been eliminated)
// Eventually, you will have a clues object where you can use process of elimination to manually figure out which index is which attribute

const attributes = new Array();

const parseData = async (fn) => {
  const rawData = await getData(fn, "\n\n", false);
  [allowables, myTicket, theRest] = rawData;
  return { allowables, myTicket, theRest };
};

const parseAllowables = (allowables) => {
  const lines = allowables.split("\n");
  for (const line of lines) {
    const parsedLine = line.split(": ");
    const attribute = parsedLine[0];
    attributes.push(attribute);
    const intervalA = parsedLine[1].split(" or ")[0];
    const intervalB = parsedLine[1].split(" or ")[1];
    intervalTree.insert({
      low: Number(intervalA.split("-")[0]),
      high: Number(intervalA.split("-")[1]),
      attribute,
    });
    intervalTree.insert({
      low: Number(intervalB.split("-")[0]),
      high: Number(intervalB.split("-")[1]),
      attribute,
    });
    // Inserting an "anti-matching" interval, which is used in Part 2 to figure out which attributes a certain position in the array cannot correspond to
    intervalTree.insert({
      low: Number(intervalA.split("-")[1]) + 1,
      high: Number(intervalB.split("-")[0]) - 1,
      not: attribute,
    });
  }
};

const solve = async (fn) => {
  const parsed = await parseData(fn);
  const {allowables, myTicket, theRest} = parsed;
  parseAllowables(allowables);
  const tickets = theRest.split("\n").slice(1);
  let validTickets = tickets; // Saving a copy here to be spliced later
  tickets.splice(0, 0, myTicket.split("\n")[1]);
  console.log("Tickets are: ", tickets);
  const errors = new Array();
  tickets.forEach((ticket) => {
    const numbers = ticket.split(",").map((str) => Number(str));
    for (const number of numbers) {
      if (intervalTree.search(number, number).length === 0) {
        errors.push({ number, ticket });
      }
    }
  });
  const invalidNumbers = errors.map((obj) => obj.number);
  const sum = invalidNumbers.reduce((acc, val) => acc + val);
  console.log(`Sum is ${sum}`);
  // PART 2
  const ticketsToRemove = errors.map((obj) => obj.ticket);
  for (const ticket of ticketsToRemove) {
    const ind = validTickets.indexOf(ticket);
    validTickets.splice(ind, 1);
  }
  const inspectThis = new Array();
  for (let i = 0; i < validTickets[0].split(",").length; i++) {
    const arr = validTickets.map((ticket) => Number(ticket.split(",")[i]));
    inspectThis[i] = {
      index: i,
      values: arr.sort((a, b) => a - b),
    };
  }
  const clues = new Array();
  for (const position of inspectThis) {
    for (const value of position.values) {
      thisValue = intervalTree
        .search(value, value)
        .filter((obj) => obj.not)
        .map((obj) => obj.not);
      if (thisValue.length) {
        console.log(`At ${value}, ${thisValue}`);
        if (clues[position.index]) {
          console.log(`Inserting ${thisValue} at position ${position.index}`);
          clues[position.index].push(thisValue[0]);
        } else {
          clues[position.index] = [thisValue[0]];
        }
      }
    }
  }
  console.log(clues);
  sortedClues = clues.map((unsorted, index) => {
    return {
      index,
      eliminate: unsorted.sort(),
    };
  });
  const possibilities = new Object();
  for (const attribute of attributes) {
    possibilities[attribute] = sortedClues
      .filter((val) => {
        return !val.eliminate.includes(attribute);
      })
      .map((val) => val.index);
  }
  await writeFile("./16-output.json", JSON.stringify(possibilities));
  return myTicket.split(',');
};

const multiplySixNumbers = async (arr, ticket) => {
  const product = ticket.filter((val, ind) => arr.includes(ind)).reduce((acc, val) => acc * val);
  console.log(`The answer is ${product}`);
};

// solve('./16-test.txt'); // Mote: Make sure this is commented out. Since there is only a single instance of intervalTree, running multiple
// solves will cause the output to be incorrect.

solve("./16-input.txt")
.then(myTicket => multiplySixNumbers([3, 4, 12, 14, 15, 17], myTicket));
 // Output: Sum is 23054