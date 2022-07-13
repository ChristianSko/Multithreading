//
//  ContentView.swift
//  Multithreading
//
//  Created by Christian Skorobogatow on 13/7/22.
//

import SwiftUI


class BackgroundThreadViewModel: ObservableObject {
    
    @Published var dataArray = [String]()
    
    func fetchData() {
        
        DispatchQueue.global(qos: .background).async {
            let newData = self.downloadedData()
            
            print("CHECK 1 \(Thread.isMainThread)")
            print("CHECK 1 \(Thread.current)")
            
            DispatchQueue.main.async {
                self.dataArray = newData
                
                print("CHECK 2 \(Thread.isMainThread)")
                print("CHECK 2 \(Thread.current)")
            }
        }
    }
    
    func downloadedData() -> [String] {
        var data: [String] = []
        
        for x in 0..<100 {
            data.append("\(x)")
            print(data)
        }
        
        return data
    }
    
}

struct ContentView: View {
    
    @StateObject var vm = BackgroundThreadViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                Text("LOAD DATA")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .onTapGesture {
                        vm.fetchData()
                    }
                
                ForEach(vm.dataArray, id: \.self) { item in
                    Text(item)
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
