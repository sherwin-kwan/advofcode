
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

const DATA: &str = "./input.txt";

fn main() {
  let instructions = vec!["forward 5", "down 5", "forward 8", "up 3", "down 8", "forward 2"];
  let mut location = 0;
  let mut depth = 0;
  let mut aim = 0;
  for line in instructions.iter() {
    let split_line = line.split(" ");
    let vec = split_line.collect::<Vec<&str>>();
    match vec[0] {
      "forward" => {
        let units: i32 = vec[1].parse().unwrap();
        location += units;
        depth += aim * units;
      }
      "down" => {
        let units: i32 = vec[1].parse().unwrap();
        aim += units;
      }
      // Up
      _ => {
        let units: i32 = vec[1].parse().unwrap();
        aim -= units;
      }
    }
  };
  println!("{}", location * depth)
}