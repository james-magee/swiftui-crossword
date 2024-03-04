//
//  Board.swift
//  nytmini-backport-ios
//
//  Created by James Magee on 2/9/24.
//

import Foundation


struct Board {
  let numRows: Int
  let numCols: Int
  let acrossHints: [Hint]
  let downHints: [Hint]
  let rows: [Row]
}

struct Square {
  let correctLetter: String?
  let number: Int?
}

struct Row {
  let squares: [Square]
}

struct Hint {
  let number: Int
  let content: String
}

// EXAMPLE

func buildTestBoard() -> Board {
  let row1 = Row(squares: [
    Square(correctLetter: nil, number: nil),
    Square(correctLetter: nil, number: nil),
    Square(correctLetter: nil, number: nil),
    Square(correctLetter: "t", number: 1),
    Square(correctLetter: "a", number: 2),
    Square(correctLetter: "g", number: 3),
    Square(correctLetter: "s", number: 4),
  ])
  
  let row2 = Row(squares: [
    Square(correctLetter: nil, number: nil),
    Square(correctLetter: nil, number: nil),
    Square(correctLetter: nil, number: nil),
    Square(correctLetter: "u", number: 5),
    Square(correctLetter: "n", number: nil),
    Square(correctLetter: "d", number: nil),
    Square(correctLetter: "o", number: nil),
  ])
  
  let row3 = Row(squares: [
    Square(correctLetter: nil, number: nil),
    Square(correctLetter: nil, number: nil),
    Square(correctLetter: "o", number: 6),
    Square(correctLetter: "r", number: nil),
    Square(correctLetter: "g", number: nil),
    Square(correctLetter: "a", number: nil),
    Square(correctLetter: "n", number: nil),
  ])
  
  let row4 = Row(squares: [
    Square(correctLetter: "c", number: 7),
    Square(correctLetter: "a", number: 8),
    Square(correctLetter: "r", number: nil),
    Square(correctLetter: "k", number: nil),
    Square(correctLetter: "e", number: nil),
    Square(correctLetter: "y", number: nil),
    Square(correctLetter: "s", number: nil),
  ])
  
  let row5 = Row(squares: [
    Square(correctLetter: "o", number: 9),
    Square(correctLetter: "l", number: nil),
    Square(correctLetter: "d", number: nil),
    Square(correctLetter: "e", number: nil),
    Square(correctLetter: "r", number: nil),
    Square(correctLetter: nil, number: nil),
    Square(correctLetter: nil, number: nil),
  ])
  
  let row6 = Row(squares: [
    Square(correctLetter: "o", number: 10),
    Square(correctLetter: "b", number: nil),
    Square(correctLetter: "e", number: nil),
    Square(correctLetter: "y", number: nil),
    Square(correctLetter: nil, number: nil),
    Square(correctLetter: nil, number: nil),
    Square(correctLetter: nil, number: nil),
  ])
  
  let row7 = Row(squares: [
    Square(correctLetter: "p", number: 11),
    Square(correctLetter: "a", number: nil),
    Square(correctLetter: "r", number: nil),
    Square(correctLetter: "s", number: nil),
    Square(correctLetter: nil, number: nil),
    Square(correctLetter: nil, number: nil),
    Square(correctLetter: nil, number: nil),
  ])
  
  let acrossHints = [
    Hint(number: 1, content: "Makes \"it\" in a game"),
    Hint(number: 5, content: "Go back, on a computer"),
    Hint(number: 6, content: "Heart or kidney"),
    Hint(number: 7, content: "Beetles, Mustangs and Jaguars use them"),
    Hint(number: 9, content: "Like Luke Hemsworth, vis-a-vis Chris Hemsworth"),
    Hint(number: 10, content: "Follow, as orders"),
    Hint(number: 11, content: "Good golf scores"),
  ]
  
  let downHints = [
    Hint(number: 7, content: "Folk rock's Mumford & ___"),
    Hint(number: 1, content: "Gobbling group"),
    Hint(number: 5, content: "Emotion for a hothead"),
    Hint(number: 6, content: "Down under greeting"),
    Hint(number: 7, content: "Folk rock's Mumford & ___"),
    Hint(number: 9, content: "Judge's shout with the bang of gavel"),
    Hint(number: 10, content: "Henhouse"),
    Hint(number: 11, content: "Actress Jessica of \"Fantastic Four\""),
  ]
  
  return Board(numRows: 7, numCols: 7, acrossHints: acrossHints, downHints: downHints, rows: [row1,row2,row3,row4,row5,row6,row7])
}

