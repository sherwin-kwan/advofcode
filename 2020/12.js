const { getData } = require("./helpers");

// Parse the data into an array of direction/value instructions
// Set up three variables for heading, northing, and easting and adjust according to instructions
// PART 2:
// Set up two objects, a waypoint object with a northing and easting, and a ship object with a northing and easting
// Adjust according to instructions

const parseData = async (fn) => {
  const rawData = await getData(fn, "\n", false);
  return rawData.map((str) => {
    // Convert all turns to right turns
    if (str.slice(0, 1) === "L") {
      return {
        direction: "R",
        value: 360 - Number(str.slice(1)),
      };
    } else {
      return {
        direction: str.slice(0, 1),
        value: Number(str.slice(1)),
      };
    }
  });
};

const findLocation = async (fn) => {
  const data = await parseData(fn);
  let heading = 90;
  let northing = 0;
  let easting = 0;
  for (const instruction of data) {
    const { direction, value } = instruction;
    if (direction === "N" || (direction === "F" && heading === 0))
      northing += value;
    if (direction === "E" || (direction === "F" && heading === 90))
      easting += value;
    if (direction === "S" || (direction === "F" && heading === 180))
      northing -= value;
    if (direction === "W" || (direction === "F" && heading === 270))
      easting -= value;
    if (direction === "R") heading = (heading + value) % 360;
    console.log(northing, easting);
  }
  console.log(
    `Ship is now at ${
      Math.abs(northing) + Math.abs(easting)
    } Manhattan distance away from origin, facing ${heading}`
  );
};

const rotateWaypoint = (waypoint, angle) => {
  if (angle === 180) {
    return {
      north: -waypoint.north,
      east: -waypoint.east
    }
  } else if (angle === 90) {
    return {
      north: -waypoint.east,
      east: waypoint.north
    }
  } else if (angle === 270) {
    return {
      north: waypoint.east,
      east: -waypoint.north
    }
  } else {
    console.log('Turn not recognized');
    return waypoint; 
  }
};

const findLocationWithWaypoints = async (fn) => {
  const data = await parseData(fn);
  let ship = { north: 0, east: 0 };
  let waypoint = { north: 1, east: 10 };
  for (const instruction of data) {
    const {direction, value} = instruction;
    switch(direction) {
      case "N":
        waypoint.north += value;
        break;
      case "E":
        waypoint.east += value;
        break;
      case "S":
        waypoint.north -= value;
        break;
      case "W":
        waypoint.east -= value;
        break;
      case "R":
        waypoint = rotateWaypoint(waypoint, value);
        break;
      case "F":
        ship.north += value * waypoint.north;
        ship.east += value * waypoint.east;
    };
    console.log(ship);
  };
  console.log(
    `Ship is now at ${
      Math.abs(ship.north) + Math.abs(ship.east)
    } Manhattan distance away from origin, with waypoint at ${waypoint.north}, ${waypoint.east}}`
  );
};

findLocation("./12-input.txt"); // Output: Ship is now at 508 Manhattan distance away from origin, facing 0
findLocationWithWaypoints("./12-input.txt"); // Output: Ship is now at 30761 Manhattan distance away from origin, with waypoint at 16, 19}
