// Develop a coordinate system: first coordinate (E) is east, second coordinate (Y) is northwest
// Thus northeast by 1 would be (1, 1)
// Parse the file, turning "NW", "NE", "SE", "SW" into "Y, YE, Z, ZW"
// Count E's, subtract count of W's, to find the E coordinate. Count Ys, subtract count of Zs, to find the Y coordinate
// Start with origin at [100, 100], that should provide enough space without going into negative array values (hopefully?)
// Create a 2D array to track the state of each tile. undefined or false is white, true is black

const { getData } = require("./helpers");

const getTiles = async (fn) => {
  const data = await getData(fn, "\n", false);
  processedData = data.map((line) => {
    line1 = line.replace(/nw/g, "y");
    line2 = line1.replace(/ne/g, "ye");
    line3 = line2.replace(/se/g, "z");
    line4 = line3.replace(/sw/g, "zw");
    eMatches = line4.match(/e/g) ? line4.match(/e/g).length : 0;
    wMatches = line4.match(/w/g) ? line4.match(/w/g).length : 0;
    yMatches = line4.match(/y/g) ? line4.match(/y/g).length : 0;
    zMatches = line4.match(/z/g) ? line4.match(/z/g).length : 0;
    eastCoordinate = eMatches - wMatches + 200;
    yCoordinate = yMatches - zMatches + 200;
    return [eastCoordinate, yCoordinate];
  });
  return processedData;
};

const initialFlipTiles = (processedData, tiles) => {
  for (const tile of processedData) {
    tiles[tile[0]][tile[1]] = !tiles[tile[0]][tile[1]];
  }
  console.log(`Initially there are ${blackTiles(tiles)} black tiles.`);
};

const countBlackNeighbours = (eCoord, yCoord, tiles) => {
  const neighbouringTiles = [
    tiles[eCoord][yCoord+1],
    tiles[eCoord][yCoord-1],
    tiles[eCoord+1][yCoord],
    tiles[eCoord-1][yCoord],
    tiles[eCoord-1][yCoord-1],
    tiles[eCoord+1][yCoord+1],
  ];
  return neighbouringTiles.reduce((acc, val) => acc + val, 0);
};

// Abusing the fact that false is coerced into 0 and true into 1 in JavaScript
const blackTiles = (tiles) => {
  return tiles.reduce((acc, arr) => acc + arr.reduce((acc, val) => acc + val, 0), 0);
};

getTiles("./24-input.txt").then((res) => {
  const tiles = [];
  for (let a = 0; a < 350; a++) {
    tiles[a] = [];
    for (let b = 0; b < 350; b++) {
      tiles[a][b] = false;
    }
  }
  let activeRange = [180, 220]; // Range of tiles's e and y coordinates to check to see if they need to be flipped
  initialFlipTiles(res, tiles);
  console.log("neighbours: ", countBlackNeighbours(200, 199, tiles));
  // Flip tiles
  for (let i = 1; i <= 100; i++) {
    const forFlip = new Array();
    for (let e = activeRange[0]; e <= activeRange[1]; e++) {
      for (let y = activeRange[0]; y <= activeRange[1]; y++) {
        if (tiles[e][y] && [0, 3, 4, 5, 6].includes(countBlackNeighbours(e, y, tiles))) {
          forFlip.push({east: e, y});
        } else if (!tiles[e][y] && countBlackNeighbours(e, y, tiles) === 2) {
          forFlip.push({east: e, y})
        }
      }
    }
    for (const tile of forFlip) {
      tiles[tile.east][tile.y] = !tiles[tile.east][tile.y];
    }
    activeRange[0]--; activeRange[1]++;
    console.log(
      `After day ${i}, there are ${
        blackTiles(tiles)
      } black tiles.`
    );
  }
});
