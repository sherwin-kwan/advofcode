// Develop a coordinate system: first coordinate (E) is east, second coordinate (Y) is northwest
// Thus northeast by 1 would be (1, 1)
// Parse the file, turning "NW", "NE", "SE", "SW" into "Y, YE, Z, ZW"
// Count E's, subtract count of W's, to find the E coordinate. Count Ys, subtract count of Zs, to find the Y coordinate
// Start with origin at [100, 100], that should provide enough space without going into negative array values (hopefully?)
// Create a 2D array to track the state of each tile. undefined or false is white, true is black

const { getData } = require('./helpers');

const tiles = new Array;

const getTiles = async (fn) => {
  const data = await getData(fn, '\n', false);
  processedData = data.map(line => {
    line1 = line.replace(/nw/g, "y");
    line2 = line1.replace(/ne/g, "ye");
    line3 = line2.replace(/se/g, "z");
    line4 = line3.replace(/sw/g, "zw");
    eMatches = line4.match(/e/g) ? line4.match(/e/g).length : 0;
    wMatches = line4.match(/w/g) ? line4.match(/w/g).length : 0;
    yMatches = line4.match(/y/g) ? line4.match(/y/g).length : 0;
    zMatches = line4.match(/z/g) ? line4.match(/z/g).length : 0;
    eastCoordinate = eMatches - wMatches + 50;
    yCoordinate = yMatches - zMatches + 50;
    return [eastCoordinate, yCoordinate]
  });
  console.log(processedData);
  return processedData;
};

const flipTiles = (processedData) => {
  for (const tile of processedData) {
    index = String(tile[0]) + String(tile[1]);
    tiles[index] = !tiles[index]
  };
  const blackTiles = tiles.filter(val => val).length;
  console.log(`There are ${blackTiles} black tiles.`);
};

getTiles('./24-input.txt')
.then(res => flipTiles(res));