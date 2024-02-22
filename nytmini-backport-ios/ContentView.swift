//
//  ContentView.swift
//  nytmini-backport-ios
//
//  Created by James Magee on 2/3/24.
//
//
//  Board.swift
//  nytmini-backport-ios
//
//  Created by James Magee on 2/9/24.
//
import SwiftUI
import SwiftData

let sqLength = 55.0
let highlightColor = Color.blue.opacity(0.25)


struct SquareState: Identifiable {
  let id: String
  let initial: Square
  let row: Int    // row and column used for highlighting
  let col: Int
  var currentLetter: String
}

enum Axis {
  case column, row
}
struct Highlight {
  let axisHighlighted: Axis
  let which: Int
}


struct ContentView: View {
  let boardInput: Board
  let numRows: Int
  let numCols: Int
  @State private var boardState: [SquareState]
  @State private var highlighted: Highlight?
  @State private var lastSquareTapped: Int?  // index of the last square that was tapped
  
  init(boardInput: Board) {
    self.boardInput = boardInput
    numRows = boardInput.numRows
    numCols = boardInput.numCols
    highlighted = nil
    var tempList: [SquareState] = []
    for (rowIndex, row) in boardInput.rows.enumerated() {
      for (colIndex, square) in row.squares.enumerated() {
        tempList.append(SquareState(id: UUID().uuidString, initial: square, row: rowIndex, col: colIndex, currentLetter: ""))
      }
    }
    boardState = tempList
  }
  
  func updateSquareLetters(index: Int, letter: String) -> [SquareState] {
    boardState[index].currentLetter = letter
    return boardState
  }
  
  /*
   * updates the which row / column is focussed from the index of square that was tapped on
   */
  func updateFocussedAxis(rowIndex: Int, colIndex: Int) {
    let index = rowIndex * numCols + colIndex
    if index == lastSquareTapped, let hl = highlighted {
      if hl.axisHighlighted == .column {
        highlighted = Highlight(axisHighlighted: .row, which: rowIndex)
      } else if highlighted!.axisHighlighted == .row {
        highlighted = Highlight(axisHighlighted: .column, which: colIndex)
      }
    } else {
      highlighted = Highlight(axisHighlighted: .row, which: rowIndex)
    }
    lastSquareTapped = index
  }
  
  func determineSqColor(rowIndex: Int, colIndex: Int) -> Color {
    if boardState[rowIndex * numCols + colIndex].initial.correctLetter == nil {
      return .black
    } else if let highlight = highlighted {
      if highlight.axisHighlighted == .column && highlight.which == colIndex {
        return highlightColor
      }
      else if highlight.axisHighlighted == .row && highlight.which == rowIndex {
        return highlightColor
      }
    }
    return .white
  }
  
  var boardView: some View {
    Grid(horizontalSpacing: -1, verticalSpacing: -1) {
      ForEach(0..<numRows) { rowIndex in
        GridRow {
          ForEach(0..<numCols) { colIndex in
            ZStack(alignment: .topLeading) {
              Rectangle()
                .fill(determineSqColor(rowIndex: rowIndex, colIndex: colIndex))
                .frame(width: sqLength, height: sqLength)
                .border(.gray, width: 0.5)
              
              if let num = boardState[rowIndex * numCols + colIndex].initial.number {
                Text("\(num)")
                  .frame(alignment: .topLeading)
                  .padding(4)
                  .font(.custom("myfont", size: 12.0))
              }
              
              Text(boardState[rowIndex * numCols + colIndex].currentLetter)
                .frame(width: sqLength, height: sqLength)
                .font(.custom("myfont", size: 24))
              
              TextField("", text: $boardState[rowIndex * numCols + colIndex].currentLetter)
                .foregroundColor(.clear)
                .background(.clear)
                .disableAutocorrection(true)
                .selectionDisabled()
                .findDisabled()
                .replaceDisabled()
                .autocorrectionDisabled()
                .interactiveDismissDisabled()
                .hoverEffectDisabled()
                .menuIndicator(.hidden)
                .frame(width: sqLength, height: sqLength)
                .accentColor(.clear)  // deprecated apparently...
                .onKeyPress { press in
                  assert(press.characters.count == 1)
                  boardState = updateSquareLetters(index: rowIndex * numCols + colIndex, letter: press.characters.uppercased())
                  return .handled
                }
                .onTapGesture {
                  updateFocussedAxis(rowIndex: rowIndex, colIndex: colIndex)
//                  lastSquareTapped = rowIndex * numCols + colIndex
                }
              
              
              
//                .onTapGesture(count: 1) {
//                  if lastSquareTapped != nil && lastSquareTapped == rowIndex * numCols + colIndex {
//                    highlighted = updateSelectedAxis(axisIndex: colIndex, axis: Axis.column)
//                    lastSquareTapped = nil
//                  } else {
//                    highlighted = updateSelectedAxis(axisIndex: rowIndex, axis: Axis.row)
//                    lastSquareTapped = rowIndex * numCols + colIndex
//                  }
//                }
            }
          }
        }
      }
    }
  }
  
  var body: some View {
    VStack() {
//      Spacer()
//        .frame(idealHeight: 15)
//        .fixedSize()
//      HStack(spacing: 10.0) {
//        Spacer()
//        hintsView
//        Spacer()
//        hintsView
//        Spacer()
//
//      }
//      Spacer()
//        .frame(idealHeight: 35)
//        .fixedSize()
      boardView
      Spacer()
    }
  }
  
//  var hintsView: some View {
//    Grid(alignment: .leading, verticalSpacing: 6.0) {
//      Text("ACROSS")
//      ForEach(buildTestBoard().acrossHints) { hint in
//        GridRow {
//          Text("\(hint.number)")
//            .font(.system(size: 11))
//            .bold()
//          Text(hint.content)
//            .font(.system(size: 10))
//        }
//      }
//    }
//  }
}

#Preview {
  ContentView(boardInput: buildTestBoard())
}
