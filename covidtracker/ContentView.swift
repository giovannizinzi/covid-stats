//
//  ContentView.swift
//  covidtracker
//
//  Created by Giovanni Zinzi on 1/11/22.
// UI screen.mainbounds.width is an interesting way to logically space things

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HomeView: View {
    @State var index = 0
    var body: some View{
        
        VStack {
            
            VStack(spacing: 18){
                
                HStack{
                    
                    Text("Daily Covid Statistics")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        //their country? Maybe could have info on where the statistics are from?
                        Image(systemName: "info.circle")
                            .foregroundColor(.white)
                            .scaleEffect(1.5)
                    }
                }
                .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 15)
                
                HStack{
                    //This city can be populated dynamically
                    Button(action: {
                        self.index = 0
                    }) {
                        Text("My City")
                            .foregroundColor(self.index == 0 ? .black : .white)
                            .padding(.vertical, 12)
                            .frame(width: (UIScreen.main.bounds.width/2) - 30)
                    }
                    .background(self.index == 0 ? Color.white : Color.clear)
                    .clipShape(Capsule())
                    //This would just be USA wide statistics
                    Button(action: {
                        self.index = 1
                    }) {
                        Text("USA")
                            .foregroundColor(self.index == 1 ? .black : .white)
                            .padding(.vertical, 12)
                            .frame(width: (UIScreen.main.bounds.width/2) - 30)
                    }
                    .background(self.index == 1 ? Color.white : Color.clear)
                    .clipShape(Capsule())
                    
                }
                .background(Color.black.opacity(0.25))
                .clipShape(Capsule())
                .padding(.top, 10)
                
                HStack(spacing: 15){
                    
                    VStack(spacing: 12){
                        Text("Affected")
                        Text("220,000")
                            .fontWeight(.bold)
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                    .background(Color("affected"))
                    .cornerRadius(12)
                    
                    VStack(spacing: 12){
                        Text("Deaths")
                        Text("10,000")
                            .fontWeight(.bold)
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                    .background(Color("death"))
                    .cornerRadius(12)
                    
                }
                
                HStack(spacing: 15){
                    
                    VStack(spacing: 12){
                        Text("Active")
                        Text("109,000")
                            .fontWeight(.bold)
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                    .background(Color("active"))
                    .cornerRadius(12)
                    
                    VStack(spacing: 12){
                        Text("Recovered")
                        Text("502,000")
                            .fontWeight(.bold)
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                    .background(Color("recovered"))
                    .cornerRadius(12)
                    
                    VStack(spacing: 12){
                        Text("Serious")
                        Text("95,000")
                            .fontWeight(.bold)
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                    .background(Color("serious"))
                    .cornerRadius(12)
                    
                }
                
                
                
            }
            .background(Color("bg"))
            .padding(.horizontal)
            .padding(.bottom, 45)
            
            Spacer()
        }
        .background(Color("bg"))
        .edgesIgnoringSafeArea(.all)
    }
}
