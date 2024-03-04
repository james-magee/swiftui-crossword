//
//  ContentViewViewModel.swift
//  nytmini-backport-ios
//
//  Created by James Magee on 2/19/24.
//

import Foundation
import SwiftUI
import UIKit

enum Axis {
  case column, row
}

enum MyError: Error {
  case badbad
}

let darkColor = Color(red: 14/255, green: 61/255, blue: 56/255)

extension ContentView {
  @Observable
  class ViewModel {
    var boardState = [[SquareState]]()
    var squareSelected: (Int, Int)?
    var textInput: String
    var oldTextInput: String
    var axisSelected: Axis?   // whether a row or column is selected
    var selected: Int?        // which indices (row or column spaces) are selected
    let rowLength: Int	
    let rowCount: Int
    let initBoard: Board
    
    init(board: Board) {
      var colList: [[SquareState]] = []
      for (_, row) in board.rows.enumerated() {
        var rowList: [SquareState] = []
        for (_, _) in row.squares.enumerated() {
          rowList.append(SquareState(id: UUID().uuidString, selected: false, letter: ""))
        }
        colList.append(rowList)
      }
      initBoard = board
      boardState = colList
      rowLength = board.numCols
      rowCount = board.numRows
      textInput = "dl;kfjasl;fjdslajfklsajlf;jksaldjf;jsakfajsdlfj;;kasjfd;ajk"
      oldTextInput = "dl;kfjasl;fjdslajfklsajlf;jksaldjf;jsakfajsdlfj;;kasjfd;ajk"
    }
    
    func computeSquareLength () -> CGFloat {
      assert(initBoard.rows.count > 0)
      assert(initBoard.rows.count == initBoard.rows[0].squares.count)
      return (UIScreen.main.bounds.width - 20) / CGFloat(initBoard.rows.count)
    }
    
    /**
     *  Note: this handler is called by onChange, between receiving the new value of textInput and updating textInput
     *    -- this means that any change to textInput in the below function will have no effects outside the function's scope
     *    TODO: improve this so that a single method can handle all behavior desired from textinput
     *
     *    -- putting textInput = "" in .onDisappear seems to work, BUT
     *      ideally we create a custom wrapper for String that behaves like a string except it can only store one character ... so everytime it gets set, it just overwrites the old char... ???
     */
    
    func handleCharacterChange() throws {
      guard let (row, col) = squareSelected, let axisSelected else {        // this handler should only be called when a square and axis are selected
        throw MyError.badbad
      }
      
      let old = oldTextInput
      let new = textInput
      oldTextInput = textInput
      
      func canSelectSquare(offset: Int) -> Bool {
        if axisSelected == .row {
          return (col + offset) < rowLength &&
          (col + offset) >= 0 &&
          initBoard.rows[row].squares[col + offset].correctLetter != nil
        }
        else {
          return (row + offset) < rowCount &&
          (row + offset) >= 0 &&
          initBoard.rows[row + offset].squares[col].correctLetter != nil
        }
      }
      
      guard old.count < new.count else {                                    // indicates backspace was pressed
        if boardState[row][col].letter != "" {
          boardState[row][col].letter = ""                                  // if current square has a letter, just delete it and return
        }
        else {                                                              // if current square doesn't have letter, move backwards and delete
          if axisSelected == .row && canSelectSquare(offset: -1) {
            squareSelected = (row, col - 1)
            boardState[row][col - 1].letter = ""
          }
          if axisSelected == .column && canSelectSquare(offset: -1) {
            squareSelected = (row - 1, col)
            boardState[row - 1][col].letter = ""
          }
        }
        return
      }
      
      let input = new[new.index(before: new.endIndex)]
      boardState[row][col].letter = input.uppercased()
      if axisSelected == .row && canSelectSquare(offset: 1) {
        squareSelected = (row, col + 1)
      }
      if axisSelected == .column && canSelectSquare(offset: 1) {
        squareSelected = (row + 1, col)
      }
    }
    
    
    func colorAt(row: Int, col: Int) -> Color {
      if initBoard.rows[row].squares[col].correctLetter == nil {
        return .secondaryColor
      }
      else if let squareSelected, squareSelected == (row, col) {
        return .tertiaryColor
      }
      else if let axisSelected, let selected {
        if (axisSelected == .column && selected == col) || (axisSelected == .row && selected == row) {
          return .quaternaryColor
        }
      }
      return .primaryColor
    }
    
    func borderWidthAt(row: Int, col: Int) -> CGFloat {
      if initBoard.rows[row].squares[col].correctLetter == nil {
        return 0.0
      }
      return 0.5
    }
    
    
    func letterAt(row: Int, col: Int) -> String {
      return boardState[row][col].letter
    }
    
    
    /**
     * selects column if this is square is currently selected; otherwise selects row
     */
    func handleTapAt(row: Int, col: Int) {
      guard initBoard.rows[row].squares[col].correctLetter != nil else {
        return
      }
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
    
    func numAt(row: Int, col: Int) -> Int? {
      if let num = initBoard.rows[row].squares[col].number {
        return num
      }
      return nil
    }
    
    func currentHint() -> String {
      guard let selected, let axisSelected else {
        return ""
      }
      if axisSelected == .row {
        return initBoard.acrossHints[selected].content
      } else {
        return initBoard.downHints[selected].content
      }
    }
  }
}

struct SquareState: Identifiable {
  let id: String
  var selected: Bool
  var letter: String
}
