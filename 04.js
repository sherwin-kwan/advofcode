// Take input file and split it into its component passports (probably have to look for double-newlines as separator)
// Iterate through the passports, for each one, check if all seven required parameters are present
// If so, increment counter and go to next passport. If not, go to next passport.

// Workaround: I deleted the newline character at the end of 04-input.txt to make it parse correctly as JSON

const { getData } = require("./helpers");

const requiredParameters = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];


const isValid1 = (obj, params) => {
  for (const param of params) {
    if (!Object.keys(obj).includes(param)) {
      return false;
    }
  }
  return true;
};

const isValid2 = (obj, params) => {
  for (const param of params) {
    if (!Object.keys(obj).includes(param)) {
      return false;
    }
  }
  return true;
}

async function countValidPassports(checkValid) {
  const rawData = await getData("04-input.txt", "\n\n", true);
  const data = rawData.map(passport => parseJson(passport));
  console.log('Last few: ', data[data.length - 3], 'and', data[data.length - 2], 'and', data[data.length - 1]);
  let counter = 0;
  for (const passport of data) {
    if (isValid1(passport, requiredParameters)) {
      counter++;
    }
  }
  console.log(`${counter} valid passports identified!`);
}

countValidPassports(false);
// Output: "260 valid passports found"
countValidPassports(true);

const parseJson = (str) => {
  // Turns the format of the raw data into JSON. First replace spaces and newlines with commas, and add the needed quotes around keys and values
  str2 = '{"' + str.replace(/[\s\n]/g, '","') + '"}';
  str3 = str2.replace(/:/g, '":"');
  return JSON.parse(str3);
};

// parseJson(
//   "eyr:2021 hgt:168cm hcl:#fffffd pid:180778832 byr:1923 ecl:amb iyr:2019 cid:241"
// );
// parseJson(`pid:#534f2e eyr:2022
// ecl:amb cid:268
// iyr:2028 hcl:2b079f
// byr:2008
// hgt:185cm`
// );