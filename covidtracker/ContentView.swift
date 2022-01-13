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
    @State var location = "Texas"
    @State var result : Result!
    @State var main : MainData!
    
    var body: some View{
        
        VStack{
        
            if self.main != nil{
            
        VStack {
            
            VStack(spacing: 15){
                
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
                        self.result = nil
                        self.main = nil
                        self.getData()
                    }) {
                        Text(location)
                            .foregroundColor(self.index == 0 ? .black : .white)
                            .padding(.vertical, 12)
                            .frame(width: (UIScreen.main.bounds.width/2) - 30)
                    }
                    .background(self.index == 0 ? Color.white : Color.clear)
                    .clipShape(Capsule())
                    //This would just be USA wide statistics
                    Button(action: {
                        self.index = 1
                        self.result = nil
                        self.main = nil
                        self.getData()
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
                        Text("Cases")
                        Text("\(self.main.value)")
                            .fontWeight(.bold)
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                    .background(Color("affected"))
                    .cornerRadius(12)
                    
                    VStack(spacing: 12){
                        Text("Deaths")
                        Text("\(self.main.value)")
                            .fontWeight(.bold)
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                    .background(Color("death"))
                    .cornerRadius(12)
                    
                }
                
                HStack(spacing: 15){
                    
                    VStack(spacing: 12){
                        Text("R")
                      + Text("t")
                          .font(.system(size: 14.0))
                          .baselineOffset(-2.0)
                        Text("1.08")
                            .fontWeight(.bold)
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                    .background(Color("active"))
                    .cornerRadius(12)
                    
                    VStack(spacing: 12){
                        Text("Recovered")
                        Text("\(self.main.value)")
                            .fontWeight(.bold)
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                    .background(Color("recovered"))
                    .cornerRadius(12)
                    
                    VStack(spacing: 12){
                        Text("Serious")
                        Text("\(self.main.value)")
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
            .padding(.bottom, 40)
            
            VStack{
                
                HStack{
                    
                    Text("New Cases - Last 7 Days")
                        .font(.title2)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.bottom, 2)
                
                HStack{

                    ForEach(0...6,id: \.self){_ in
                        
                        VStack(spacing: 10){
                            
                            Text("330K")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            GeometryReader{g in
                                
                                VStack{
                                    
                                    Spacer(minLength: 0)
                                    
                                    Capsule()
                                        .fill(Color("Color"))
                                        .frame(width: 15)
                                }
                                
                            }
                            
                            Text("4/4/20")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                        }
                        .padding(.bottom, 40)
                    }
                    
                }
            }
            .padding(.horizontal)
            .background(Color.white)
            .padding(.bottom, -20)
            .cornerRadius(20)
            .offset(y: -20)

                Text("Last Updated: " + yesterDay())
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 10)
        }
        .background(Color("bg"))
        .edgesIgnoringSafeArea(.all)
            }
            else{
                Indicator()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            self.getData()
        }
    }
    
    func getData() {
        var url = ""
        let yesterday = yesterdayForAPI()
        var state = "tx"
        if self.index == 0 {
            print("Yeserday for api:", yesterday)
            url = "https://api.covidcast.cmu.edu/epidata/covidcast/?data_source=jhu-csse&signal=confirmed_incidence_num&time_type=day&geo_type=state&time_values=" + yesterday + "&geo_value=" + state
            print(url)
        }
        //maybe should make this elif?
        else {
            print(yesterday)
            url = "https://api.covidcast.cmu.edu/epidata/covidcast/?data_source=jhu-csse&signal=confirmed_incidence_num&time_type=day&geo_type=nation&time_values=" + yesterday + "&geo_value=us"
            print(url)
        }
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if err != nil{
                print((err?.localizedDescription)!)
                return
        }
            print("here is the data", data ?? "")

            let jsonResult = try! JSONDecoder().decode(Result.self, from: data!)
            for result in jsonResult.epidata {
                print(result)
                print(result.value)
                self.main = result
            }
    }
    .resume()
    
    //url1 will contain data about
    var urlWeekly = ""
    var weekAgo = weeklyForAPI()
    print("What day was it a week ago", weekAgo)
    if self.index == 0 {
        urlWeekly = "https://api.covidcast.cmu.edu/epidata/covidcast/?data_source=jhu-csse&signal=confirmed_incidence_num&time_type=day&geo_type=state&time_values=" + yesterday + "&geo_value=" + state
        print(url)
    }
    //maybe should make this elif?
    else {
        print(yesterday)
        urlWeekly = "https://api.covidcast.cmu.edu/epidata/covidcast/?data_source=jhu-csse&signal=confirmed_incidence_num&time_type=day&geo_type=nation&time_values=" + yesterday + "&geo_value=us"
        print(url)
    }
        
    
    var urlForRt = ""
    
    }
    
    func yesterDay() -> String {
        var dayComponent = DateComponents()
        dayComponent.day = -1
        let calendar = Calendar.current
        let nextDay =  calendar.date(byAdding: dayComponent, to: Date())!
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: nextDay) //Output is "March 6, 2020
    }
    
    func yesterdayForAPI() -> String {
        var dayComponent = DateComponents()
        dayComponent.day = -1
        let calendar = Calendar.current
        let nextDay =  calendar.date(byAdding: dayComponent, to: Date())!
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: nextDay) //Output is "March 6, 2020
    }
    
    func weeklyForAPI() -> String {
        var dayComponent = DateComponents()
        dayComponent.day = -7
        let calendar = Calendar.current
        let nextDay =  calendar.date(byAdding: dayComponent, to: Date())!
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: nextDay) //Output is "March 6, 2020
    }
    
    // ok we need some sort of change here to handle the case where app crashes at midnight! Need to know when the data is refreshed too
    func twoDaysAgoForAPI() -> String {
        var dayComponent = DateComponents()
        dayComponent.day = -2
        let calendar = Calendar.current
        let nextDay =  calendar.date(byAdding: dayComponent, to: Date())!
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: nextDay) //Output is "March 6, 2020
    }
}
