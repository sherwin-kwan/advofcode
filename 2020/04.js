// Take input file and split it into its component passports (probably have to look for double-newlines as separator)
// Iterate through the passports, for each one, check if all seven required parameters are present
// If so, increment counter and go to next passport. If not, go to next passport.

// Workaround: I deleted the newline character at the end of 04-input.txt to make it parse correctly as JSON

const { getData } = require("./helpers");

const requiredParameters = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];

const valueValid = (param, value) => {
  value = value.trim(); // Just in case whitespace throws it off
  switch (param) {
    case 'byr':
      if (isNaN(Number(value)) || Number(value) < 1920 || Number(value) > 2002) return false 
      else return true;
    case 'iyr':
      if (isNaN(Number(value)) || Number(value) < 2010 || Number(value) > 2020) return false 
      else return true;
    case 'eyr':
      if (isNaN(Number(value)) || Number(value) < 2020 || Number(value) > 2030) return false 
      else return true;
    case 'hgt':
      if (value.match(/^[0-9]{3}cm$/)) {
        const heightInCm = Number(value.substring(0, 3));
        if (heightInCm >= 150 && heightInCm <= 193) return true;
        else return false;
      }
      if (value.match(/^[0-9]{2}in$/)) {
        const heightInInch = Number(value.substring(0, 2));
        if (heightInInch >= 59 && heightInInch <= 76) return true;
        else return false;
      }
      return false;
    case 'hcl':
      if (value.match(/^#[0-9a-f]{6}$/)) return true
      else return false;
    case 'ecl':
      if (['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].includes(value)) return true
      else return false;
    case 'pid':
      if (value.match(/^[0-9]{9}$/)) return true
      else return false;
  }
};

const isValid = (obj, params, strict) => {
  for (const param of params) {
    // First check if the object contains all the keys, and for each key found, check if the value is valid
    // A single error makes the whole passport invalid
    if (Object.keys(obj).includes(param)) {
      if (strict && !valueValid(param, obj[param])) return false;
    } else {
      return false;
    }
  }
  return true;
};

async function countValidPassports(strict) {
  const rawData = await getData("04-input.txt", "\n\n", false);
  const data = rawData.map(passport => parseJson(passport));
  console.log('Last few: ', data[data.length - 3], 'and', data[data.length - 2], 'and', data[data.length - 1]);
  let counter = 0;
  for (const passport of data) {
    if (isValid(passport, requiredParameters, strict)) {
      counter++;
    }
  }
  console.log(`Strict is ${strict}. ${counter} valid passports identified!`);
}

countValidPassports(false);
// Output: "Strict is false. 260 valid passports identified!"
countValidPassports(true);
// Output: "Strict is true. 153 valid passports identified!"

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