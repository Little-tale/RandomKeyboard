//
//  ContentView.swift
//  RandomKeyboard
//
//  Created by Jae hyung Kim on 8/22/24.
//

import SwiftUI

struct ContentView: View {
    
    @State
    private var numbers: [Int] = Array(0...9).shuffled()
    
    @State
    private var input: String = ""
    
    private var grid: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        contentView()
    }
}

extension ContentView {
    private func contentView() -> some View {
        VStack {
            Text("핀 번호 입력하세용")
                .font(.largeTitle)
            
            numberShowView()
            
            privateShowView()
            
            keyboardView()
        }
    }
    
    private func numberShowView() -> some View {
        Text(input)
            .font(.title)
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 60)
    }
    
    @ViewBuilder
    private func privateShowView() -> some View {

        HStack {
            ForEach(0...input.count, id: \.self) { current in
                if current != 0 {
                    Color.red
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: 10)
                        .clipShape(Circle())
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 30)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 60)
    }
    
    private func keyboardView() -> some View {
        VStack(alignment: .trailing ,spacing: 8) {
            LazyVGrid(columns: grid, alignment: .center, spacing: 8) {
                ForEach(numbers, id: \.self) { number in
                    if number != numbers.last {
                        numberView(numberItem: number)
                    }
                }
            }
            HStack {
                emptyView()
                Spacer()
                numberView(numberItem: numbers.last ?? 0)
                Spacer()
                cancelButtonView()
            }
            .padding(.horizontal)
        }
    }
    
    private func cancelButtonView() -> some View {
        Button {
            if !input.isEmpty {
                input.removeLast()
            }
        } label: {
            Image(systemName: "eraser.fill")
                .frame(width: 80, height: 80)
        }
       
    }
    
    private func emptyView() -> some View {
        Color.clear
            .frame(width: 80, height: 80)
    }
    
    private func numberView(numberItem: Int) -> some View {
        Button {
            if input.count == 6 {
                input.removeFirst()
                input += String(numberItem)
            } else {
                input += String(numberItem)
            }
        } label: {
            Text(String(numberItem))
                .font(.headline).fontWeight(.bold)
                .frame(width: 80, height: 80)
                .padding(.all, 10)
        }
        .foregroundStyle(.red)
    }
}

#Preview {
    ContentView()
}
