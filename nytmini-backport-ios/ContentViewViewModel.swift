//
//  ContentViewViewModel.swift
//  nytmini-backport-ios
//
//  Created by James Magee on 2/19/24.
//

import Foundation
import SwiftUI

enum Axis {
  case column, row
}

extension ContentView {
  @Observable
  class ViewModel {
    var boardState = [SquareState]()
    var squareSelected: (Int, Int)?
    var textInput: String
    var axisSelected: Axis?   // whether a row or column is selected
    var selected: Int?        // which indices (row or column spaces) are selected
    let rowLength: Int	
    let rowCount: Int
    let initBoard: Board
    
    init(board: Board) {
      var tempList: [SquareState] = []
      for (_, row) in board.rows.enumerated() {
        for (_, sq) in row.squares.enumerated() {
          tempList.append(SquareState(black: sq.correctLetter == nil, id: UUID().uuidString, selected: false, letter: ""))
        }
      }
      initBoard = board
      boardState = tempList
      rowLength = board.numCols
      rowCount = board.numRows
      print("REINITIALIZED...?")
      textInput = ""
    }
    private func tfi(row: Int, col: Int) -> Int {
      return row * rowLength + col
    }
    
    /**
     *  Note: this handler is called by onChange, between receiving the new value of textInput and updating textInput
     *    -- this means that any change to textInput in the below function will have no effects outside the function's scope
     *    TODO: improve this so that a single method can handle all behavior desired from textinput
     *
     *    -- putting textInput = "" in .onDisappear seems to work, BUT
     *      ideally we create a custom wrapper for String that behaves like a string except it can only store one character ... so everytime it gets set, it just overwrites the old char... ???
     */
    func handleCharacterChangeAt(index: Int) {
//      textInput = textInput.filter { return "abcdefghijklmnopqrstuvwxyz".contains($0) }
      let str = textInput[textInput.index(before: textInput.endIndex)]
      boardState[index].letter = str.uppercased()
      if let axisSelected, let squareSelected {
        let (row, col) = squareSelected
        if axisSelected == .row && col < rowLength - 1 && initBoard.rows[row].squares[col + 1].correctLetter != nil {
          self.squareSelected = (row, col + 1)
        }
        else if axisSelected == .column && row < rowCount - 1 && initBoard.rows[row + 1].squares[col].correctLetter != nil {
          self.squareSelected = (row + 1, col)
        }
      }
    }
    
    
    func colorAt(row: Int, col: Int) -> Color {
      if (boardState[row * rowLength + col].black) {
        return .black
      }
      else if let squareSelected, squareSelected == (row, col) {
        return Color.yellow.opacity(0.50)
      }
      else if let axisSelected, let selected {
        if (axisSelected == .column && selected == col) || (axisSelected == .row && selected == row) {
          return Color.blue.opacity(0.25)
        }
      }
      return .white
    }
    
    
    func letterAt(row: Int, col: Int) -> String {
      return boardState[tfi(row: row, col: col)].letter
    }
    
    
    /**
     * selects column if this is square is currently selected; otherwise selects row
     */
    func handleTapAt(row: Int, col: Int) {
      if let squareSelected, squareSelected == (row, col) {
        if axisSelected == .column {
          axisSelected = .row
          selected = row
        } else if axisSelected == .row {
          axisSelected = .column
          selected = col
        }
      } else
      if let axisSelected {
        if axisSelected == .row {
          selected = row
        } else {
          selected = col
        }
        squareSelected = (row, col)
      } else {
        axisSelected = .row
        selected = row
        squareSelected = (row, col)
      }
    }
    
    // QUESTION:
    //  should the ViewModel ever return views? ... 
    func numAt(row: Int, col: Int) -> Int? {
      if let num = initBoard.rows[row].squares[col].number {
        return num
      }
      return nil
    }
  }
}

struct SquareState: Identifiable {
  let black: Bool
  let id: String
  var selected: Bool
  var letter: String
}

//struct SquareState: Identifiable {
//  let id: String
//  let initial: Square
//  let row: Int    // row and column used for highlighting
//  let col: Int
//  var currentLetter: String
//}
