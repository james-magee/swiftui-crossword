//
//  ContentView.swift
//  nytmini-backport-ios
//
//  Created by James Magee on 2/3/24.
//
import SwiftUI
import SwiftData


struct ContentView: View {
  @State private var viewModel: ViewModel
  let sqSideLength: CGFloat
  
  init(board: Board) {
    let viewModel = ViewModel(board: board)
    self.sqSideLength = viewModel.computeSquareLength()
    self.viewModel = viewModel
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
  var KeyboardInput: some View {
    ZStack {
      if let (_, _) = viewModel.squareSelected {
        TextField("", text: $viewModel.textInput)
          .autocorrectionDisabled()
          .textInputAutocapitalization(.never)
          .frame(width: 0, height: 100)
          .foregroundColor(.clear)
          .background(.clear)
          .accentColor(.clear)
          .focused($textFocussed)
          .onChange(of: viewModel.textInput) {
            do {
              try viewModel.handleCharacterChange()
            } catch {
              print("Problem")
            }
          }
          .onAppear {
            withAnimation(.easeInOut(duration: 5.0)) {
              self.textFocussed = true
            }
          }
          .onSubmit {
            withAnimation(.easeInOut(duration: 0.25)) {
              viewModel.squareSelected = nil
              viewModel.axisSelected = nil
              viewModel.selected = nil
            }
            self.textFocussed = false
          }
      } else {
        EmptyView()
      }
    }
    .transition(.opacity)
  }
  
  var boardView: some View {
    VStack {
      Grid(horizontalSpacing: -1, verticalSpacing: -1) {
        ForEach(0..<viewModel.rowCount) { rowIndex in
          GridRow {
            ForEach(0..<viewModel.rowLength) { colIndex in
              ZStack(alignment: .topLeading) {
                if viewModel.initBoard.rows[rowIndex].squares[colIndex].correctLetter == nil {
                  Rectangle()
                    .fill(viewModel.colorAt(row: rowIndex, col: colIndex))
                    .frame(width: sqSideLength, height: sqSideLength)
                    .border(Color.primaryColor, width: 0.5)
                } else {
                  Rectangle()
                    .fill(viewModel.colorAt(row: rowIndex, col: colIndex))
                    .frame(width: sqSideLength, height: sqSideLength)
                    .border(Color.secondaryColor, width: viewModel.borderWidthAt(row: rowIndex, col: colIndex))
                    .onTapGesture(count: 1) {
                      if viewModel.squareSelected != nil {
                        viewModel.handleTapAt(row: rowIndex, col: colIndex)
                      } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                          viewModel.handleTapAt(row: rowIndex, col: colIndex)
                        }
                      }
                    }
                  SquareNumber(row: rowIndex, col: colIndex)
                  Text(viewModel.letterAt(row: rowIndex, col: colIndex))
                    .frame(width: sqSideLength, height: sqSideLength)
                    .font(.custom("myfont", size: 24))
//                    .font(.system(size: 24))
                }
              }
            }
          }
        }
      }
      KeyboardInput
    }
  }
  
  @State var offsetFromTop = 0.0
  var body: some View {
    VStack() {
      ZStack {
        if viewModel.squareSelected == nil {
          AllHintsView
        } else {
          HighlightedHintView
        }
      }
      .transition(.opacity)
      Spacer()
        .frame(idealHeight: 15)
        .fixedSize()
      boardView
      Spacer()
    }
  }
  
  var AllHintsView: some View {
    VStack {
      Spacer()
        .frame(idealHeight: 15)
        .fixedSize()
      HStack(alignment: .top, spacing: 10.0) {
        Spacer()
        AcrossHintsView
        Spacer()
        DownHintsView
        Spacer()
      }
    }
  }
  
  var HighlightedHintView: some View {
    VStack {
      Spacer()
        .frame(idealHeight: 125)
        .fixedSize()
      ZStack {
        Rectangle()
          .fill(Color.quaternaryColor)
          .frame(width: 7 * 55 - 6, height: 60)
        Text("\(viewModel.currentHint())")
      }
    }
  }
  
  var DownHintsView: some View {
    Grid(alignment: .leading, verticalSpacing: 8.0) {
      Text("Down")
        .frame(alignment: .trailing)
        .padding(5.0)
        .background(.black)
        .foregroundColor(.white)
      ForEach(0..<viewModel.initBoard.downHints.count) { hintIndex in
        GridRow(alignment: .top) {
          Text("\(viewModel.initBoard.downHints[hintIndex].number)")
            .font(.system(size: 14))
            .bold()
          Text(viewModel.initBoard.downHints[hintIndex].content)
            .font(.system(size: 14))
        }
      }
    }
  }
  
  var AcrossHintsView: some View {
    Grid(alignment: .leading, verticalSpacing: 8.0) {
      Text("Across")
        .padding(5.0)
        .background(.black)
        .foregroundColor(.white)
      ForEach(0..<viewModel.initBoard.acrossHints.count) { hintIndex in
        GridRow(alignment: .top) {
          Text("\(viewModel.initBoard.acrossHints[hintIndex].number)")
            .font(.system(size: 14))
            .bold()
          Text(viewModel.initBoard.acrossHints[hintIndex].content)
            .font(.system(size: 14))
        }
      }
    }
  }
}

#Preview {
  ContentView(board: buildTestBoard())
}
