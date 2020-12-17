// fs.promises API readfile
const { readFile } = require("fs").promises;

// Arguments: filename, separator to look for, log? (true = log the file contents, false = don't)
async function getData(fn, separator, log) {
  const contents = await readFile(fn, "utf-8");
  const arr = contents.split(separator);
  if (log) console.log(arr);
  return arr;
}

module.exports = { getData };