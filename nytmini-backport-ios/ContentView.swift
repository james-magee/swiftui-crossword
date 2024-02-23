//
//  ContentView.swift
//  nytmini-backport-ios
//
//  Created by James Magee on 2/3/24.
//
import SwiftUI
import SwiftData

let sqLength = 55.0

struct ContentView: View {
  @State private var viewModel: ViewModel
  
  init(board: Board) {
    viewModel = ViewModel(board: board)
  }
  
  @ViewBuilder
  private func SquareNumber(row: Int, col: Int) -> some View {
    if let n = viewModel.numAt(row: row, col: col) {
      Text("\(n)")
        .frame(alignment: .topLeading)
        .padding(5)
        .font(.custom("myfont", size: 12.0))
    }
    EmptyView()
  }
  
  @FocusState var textFocussed: Bool
  @ViewBuilder
  private func KeyboardInput() -> some View {
    if let (row, col) = viewModel.squareSelected {
      TextField("", text: $viewModel.textInput)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .frame(width: 0, height: 0)
        .foregroundColor(.clear)
        .background(.clear)
        .accentColor(.clear)
        .focused($textFocussed)
        .onChange(of: viewModel.textInput) {
          do {
            try viewModel.handleCharacterChange()
          } catch {
            print("oh no")
          }
        }
        .onAppear {
          self.textFocussed = true
        }
    } else {
      EmptyView()
    }
  }
  
  var boardView: some View {
    VStack {
      Grid(horizontalSpacing: -1, verticalSpacing: -1) {
        ForEach(0..<viewModel.rowCount) { rowIndex in
          GridRow {
            ForEach(0..<viewModel.rowLength) { colIndex in
              ZStack(alignment: .topLeading) {
                Rectangle()
                  .fill(viewModel.colorAt(row: rowIndex, col: colIndex))
                  .frame(width: sqLength, height: sqLength)
                  .border(.gray, width: 0.5)
                  .onTapGesture(count: 1) {
                    viewModel.handleTapAt(row: rowIndex, col: colIndex)
                  }
                SquareNumber(row: rowIndex, col: colIndex)
                Text(viewModel.letterAt(row: rowIndex, col: colIndex))
                  .frame(width: sqLength, height: sqLength)
                  .font(.custom("myfont", size: 24))
              }
            }
          }
        }
      }
      KeyboardInput()
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
  ContentView(board: buildTestBoard())
}
