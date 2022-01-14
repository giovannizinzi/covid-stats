//
//  ContentView.swift
//  covidtracker
//
//  Created by Giovanni Zinzi on 1/11/22.
// UI screen.mainbounds.width is an interesting way to logically space things

import SwiftUI
import SwiftSoup

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
    @State var location = "TX"
    @State var result : Result!
    @State var main : MainData!
    @State var hospitalization : MainData!
    @State var drvisit : PercentageData!
    @State var death : MainData!
    @State var daily : [Daily] = []
    @State var greatest = 0
    @State var useTwoDays = false
    @State var apiTest = false
    @State var rtNumber = ""
    
    //Need to add one for Rt, deaths, dr visits, hospitalizations
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showPopover: Bool = false
    //American samoa (AS) unsupported
    var dropDownList = [ "AK","AL","AR","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","PR","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"]
    var placeholder = "State"

    //American samoa (AS) unsupported
    var dictionaryForLookup = ["AK": "alaska", "AL": "alabama", "AR": "arkansas","AZ": "arizona", "CA": "california", "CO": "colorado", "CT": "connecticut", "DC": "district-of-columbia", "DE": "delaware", "FL": "florida", "GA": "georgia", "GU": "guam", "HI": "hawaii", "IA": "iowa", "ID": "idaho", "IL": "illinois", "IN": "indiana", "KS": "kansas", "KY": "kentucky", "LA": "louisiana", "MA": "massachusetts", "MD": "maryland", "ME": "maine", "MI": "michigan", "MN": "minnesota", "MO": "missouri", "MS": "mississippi", "MT": "montana", "NC": "north-carolina","ND": "north-dakota", "NE": "nebraska", "NH": "new-hampshire", "NJ": "new-jersey","NM": "new-mexico", "NV": "nevada", "NY": "new-york", "OH": "ohio", "OK": "oklahoma", "OR": "oregon", "PA": "pennsylvania", "PR": "puerto-rico", "RI": "rhode-island", "SC": "south-carolina", "SD": "south-dakota", "TN": "tennessee", "TX": "texas", "UT": "utah", "VA": "virginia", "VI": "virgin-islands", "VT": "vermont", "WA": "washington", "WI": "wisconsin", "WV": "west-virginia","WY": "wyoming"]
    
    var uniqueKey: String {
        UUID().uuidString
    }
    var body: some View{
        ZStack{
        VStack{
        
        if self.main != nil{
            
        VStack {
            
            VStack(spacing: 15){
                
                HStack{
                    
                    Text("Daily Covid Stats")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Button(action: {
                            self.showPopover = true }) {
                                Image(systemName: "info.circle")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.white)
                            .accentColor(.blue)
                                }.popover(
                                    isPresented: self.$showPopover
                                ) {
                                        Text("*swipe down to dismiss*").font(.system(size: 12))
                                        .padding(12)
                                        Divider()
                                        Text("What is Rt?").bold().font(.system(size: 28))
                                            .padding(12)
                                        Text("The effective reproduction rate - It measures how many other people a covid positive person is likely to infect. If below 1, then over time the virus will die down; If above 1, then the virus will continue to grow.")
                                            .padding(12)
                                        Text("Dr. Visits?").bold().font(.system(size: 28))
                                        .padding(12)
                                        Text("This is an estimated percentage of covid-related doctor's visits on a given day. This stat is unavailable at the national level.")
                                            .padding(12)
                                        Text("Hospitalized?").bold().font(.system(size: 28))
                                        .padding(12)
                                        Text("New hospital admissions with COVID-associated diagnoses.")
                                            .padding(12)
                                        Spacer()
                                        Text("*Data Sources:* The U.S. Department of Health & Human Services, Johns Hopkins University's CSSE, Carnegie Mellon University's Delphi Research Group, and the Centre for Mathematical Modelling of Infectious Diseases.").font(.system(size: 12))
                                        .padding(12)
                                }
                    Spacer()

                    Group{
                        Menu {
                            ForEach(dropDownList, id: \.self){ stateCode in
                                Button(stateCode) {
                                    self.location = stateCode
                                    self.index = 0
                                    self.result = nil
                                    self.daily = []
                                    //self.main = nil
                                    self.getData()
                                }
                            }
                        } label: {
                            VStack(spacing: 5){
                                HStack(spacing: 2){
                                    Text(location.isEmpty ? placeholder : location)
                                        .foregroundColor(location.isEmpty ? .gray : .white)
                                        .bold()
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Color.white)
                                        .font(Font.system(size: 20, weight: .bold))
                                }
                                .padding(.horizontal, 1)
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(height: 2)
                            }
                        }
                    }.frame(width: 75)
                    
                    
                }
                .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 15)
                
                HStack{
                    
                    Button(action: {
                        self.index = 0
                        self.result = nil
                        self.daily = []
                        //self.main = nil
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
                        self.daily = []
                        //self.main = nil
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
                            .fontWeight(.bold)
                        Text("\(self.main.value)")
                            .fontWeight(.bold)
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                    .background(Color("affected"))
                    .cornerRadius(12)
                    
                    VStack(spacing: 12){
                        Text("Deaths")
                            .fontWeight(.bold)
                        if(self.death != nil){
                        Text("\(self.death.value)")
                            .fontWeight(.bold)
                        }
                        else {
                            Text("?")
                        }
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                    .background(Color("death"))
                    .cornerRadius(12)
                    
                }
                
                HStack(spacing: 15){
                    
                    VStack(spacing: 12){
                        HStack{
                            Text("R")
                          + Text("t")
                              .font(.system(size: 14.0))
                              .baselineOffset(-2.0)
                        
                        }
                        Text("\(self.rtNumber)")
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                    .background(Color("active"))
                    .cornerRadius(12)
                    
                    VStack(spacing: 12){
                        Text("Hospitalized")
                        if(self.hospitalization != nil){
                        Text("\(self.hospitalization.value)")
                            .fontWeight(.bold)
                        }
                        else {
                            Text("?")
                        }
                    }
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                    .background(Color("recovered"))
                    .cornerRadius(12)
                    
                    VStack(spacing: 12){
                        Text("Dr. Visits")
                        if(self.drvisit != nil){
                            Text("\(self.drvisit.value, specifier: "%.2f")%")
                            .fontWeight(.bold)
                        }
                        else {
                            Text("?")
                        }
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
                
                HStack(){
                    if(self.daily.isEmpty) {
                        ForEach(0...6,id: \.self){_ in
                                               
                                               VStack(spacing: 10){
                                                   
                                                   Text(" ")
                                                       .font(.caption)
                                                       .foregroundColor(.gray)
                                                   
                                                   GeometryReader{g in
                                                       
                                                       VStack{
                                                           
                                                           Spacer(minLength: 0)
                                                           
                                                           Rectangle()
                                                               .fill(Color.clear)
                                                               .frame(width: 20)
                                                       }
                                                       
                                                   }
                                                   
                                                   Text(" ")
                                                       .font(.caption)
                                                       .foregroundColor(.gray)
                                                   
                                               }
                                               .padding(.bottom, 40)
                            }
                    }
                    else {
                    ForEach(self.daily){index in
                        
                        VStack(spacing: 10){
                            if(index.cases == 0) {
                                Text("???")
                                    .lineLimit(1)
                                    .font(.system(size: 9))
                                    .foregroundColor(.gray)
                            }
                            else {
                                Text("\(index.cases)")
                                    .lineLimit(1)
                                    .font(.system(size: 9))
                                    .foregroundColor(.gray)
                            }
                            
                            GeometryReader{g in
                                
                                VStack{
                                    
                                    Spacer(minLength: 0)
                                    
                                    Rectangle()
                                        .fill(Color("affected"))
                                        .frame(width: 25, height: getHeight(value: index.cases, height: g.frame(in: .global).height))
                                        .padding(.horizontal, 12)
                                }
                                
                            }
                            
                            Text("\(index.day)")
                                .lineLimit(1)
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                        }
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
                Indicator(isAnimating: .constant(true))
                Text("Fetching Data from The U.S. Department of Health & Human Services, Johns Hopkins University's CSSE, Carnegie Mellon University's Delphi Research Group, and the Centre for Mathematical Modelling of Infectious Diseases")
            }
        }
        .edgesIgnoringSafeArea(.all)
        }
        .onAppear() {
            //This then calls getdata
            self.testAPIRequest()
        }
    }
    
    //There is a performance improvement for sure lol
    func testAPIRequest() {
        var url = ""
        var mainTest : MainData!
        var yesterday = yesterdayForAPI()
        let state = self.location
            url = "https://api.covidcast.cmu.edu/epidata/covidcast/?data_source=jhu-csse&signal=confirmed_incidence_num&time_type=day&geo_type=state&time_values=" + yesterday + "&geo_value=" + state

        let session = URLSession(configuration: .default)

        session.dataTask(with: URL(string: url)!) { (data, _, err) in

            if err != nil{
                print((err?.localizedDescription)!)
                return
        }

            let jsonResult = try! JSONDecoder().decode(Result.self, from: data!)
            for result in jsonResult.epidata {
                mainTest = result
            }

            if(mainTest == nil) {
                self.useTwoDays.toggle()
                print("should be toggled")
                self.getData()
            }
            else{
                self.getData()
            }
    }
    .resume()
    }
    
    func getData() {
        var url = ""
        var yesterday = yesterdayForAPI()
        if (self.useTwoDays == true) {
            yesterday = twoDaysAgoForAPI()
        }
        let state = self.location
        if self.index == 0 {
//            print("Yeserday for api:", yesterday)
            url = "https://api.covidcast.cmu.edu/epidata/covidcast/?data_source=jhu-csse&signal=confirmed_incidence_num&time_type=day&geo_type=state&time_values=" + yesterday + "&geo_value=" + state
//            print(url)
        }
        //maybe should make this elif?
        else {
            url = "https://api.covidcast.cmu.edu/epidata/covidcast/?data_source=jhu-csse&signal=confirmed_incidence_num&time_type=day&geo_type=nation&time_values=" + yesterday + "&geo_value=us"
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
            
//            if(self.main == nil) {
//                print("DID THIS HAPPEN>>>")
//                self.useTwoDays.toggle()
//                self.index = 0
//                self.result = nil
//                self.daily = []
//                self.main = nil
//                getData()
//            }
    }
    .resume()
        
    //url1 will contain data about
    var urlWeekly = ""
    var weekAgo = weeklyForAPI()
    print("What day was it a week ago", weekAgo)
    if self.index == 0 {
        urlWeekly = "https://api.covidcast.cmu.edu/epidata/covidcast/?data_source=jhu-csse&signal=confirmed_incidence_num&time_type=day&geo_type=state&time_values=" + weekAgo + "-" + yesterday + "&geo_value=" + state
    }
    //maybe should make this elif?
    else {
        print(yesterday)
        urlWeekly = "https://api.covidcast.cmu.edu/epidata/covidcast/?data_source=jhu-csse&signal=confirmed_incidence_num&time_type=day&geo_type=nation&time_values=" + weekAgo + "-" + yesterday + "&geo_value=us"
        print(url)
    }
        
        let sessionWeekly = URLSession(configuration: .default)
        
        sessionWeekly.dataTask(with: URL(string: urlWeekly)!) { (data, _, err) in
            
            if err != nil{
                print((err?.localizedDescription)!)
                return
        }
            print("here is the data", data ?? "")
            var count = 0
            var casesList: [Int] = []
            let jsonResult = try! JSONDecoder().decode(Result.self, from: data!)
            for result in jsonResult.epidata {
                self.daily.append(Daily(id: count, day: convertDateFormat(date: String(result.time_value)), cases: result.value))
                casesList.append(result.value)
                count += 1
            }
            print(self.daily)
            self.greatest = casesList.max()!
    }
    .resume()
        
    var urlForRt = ""
    
    if self.index == 0 {
        var locationName = dictionaryForLookup["\(self.location)"]!
        print(locationName)
        urlForRt = "https://epiforecasts.io/covid/posts/subnational/united-states/" + locationName
    }
    //maybe should make this elif?
    else {
        urlForRt = "https://epiforecasts.io/covid/posts/national/united-states/"
    }
    
        let sessionRt = URLSession(configuration: .default)
        
        sessionRt.dataTask(with: URL(string: urlForRt)!) { (data, _, err) in
            
            if err != nil{
                print((err?.localizedDescription)!)
                return
        }
            print("here is RT DATA", data ?? "")
            var count = 0
            var casesList: [Int] = []
            let tempHTML = String(data: data!, encoding: .utf8)!
            parseHTML(html: tempHTML)
    }
    .resume()
        
    var urlForHospitalization = ""
    var fourDaysAgo = fourDaysAgoForAPI()

    if self.index == 0 {
        urlForHospitalization = "https://api.covidcast.cmu.edu/epidata/covidcast/?data_source=hhs&signal=confirmed_admissions_covid_1d&time_type=day&geo_type=state&time_values=" + fourDaysAgo + "&geo_value=" + state
    }
    //maybe should make this elif?
    else {
        urlForHospitalization = "https://api.covidcast.cmu.edu/epidata/covidcast/?data_source=hhs&signal=confirmed_admissions_covid_1d&time_type=day&geo_type=nation&time_values=" + fourDaysAgo + "&geo_value=us"
    }
    
        let sessionHospitalization = URLSession(configuration: .default)
        
        sessionHospitalization.dataTask(with: URL(string: urlForHospitalization)!) { (data, _, err) in
            
            if err != nil{
                print((err?.localizedDescription)!)
                return
        }
            let jsonResultHospitalization = try! JSONDecoder().decode(Result.self, from: data!)
            for resultH in jsonResultHospitalization.epidata {
                print(resultH)
                self.hospitalization = resultH
                print("hospitalization value", resultH.value)
            }
    }
    .resume()
        
        var urlDeaths = ""
        if self.index == 0 {
            urlDeaths = "https://api.covidcast.cmu.edu/epidata/covidcast/?data_source=jhu-csse&signal=deaths_incidence_num&time_type=day&geo_type=state&time_values=" + yesterday + "&geo_value=" + state
        }
        else {
            urlDeaths = "https://api.covidcast.cmu.edu/epidata/covidcast/?data_source=jhu-csse&signal=deaths_incidence_num&time_type=day&geo_type=nation&time_values=" + yesterday + "&geo_value=us"
        }
        
        let sessionDeaths = URLSession(configuration: .default)
        
        sessionDeaths.dataTask(with: URL(string: urlDeaths)!) { (data, _, err) in
            
            if err != nil{
                print((err?.localizedDescription)!)
                return
        }
            print("here is the data", data ?? "")

            let jsonResultDeaths = try! JSONDecoder().decode(Result.self, from: data!)
            for resultD in jsonResultDeaths.epidata {
                print("deaths", resultD.value)
                self.death = resultD
            }
            
    }
    .resume()
        
        var urlDrVisits = ""
        if self.index == 0 {
            urlDrVisits = "https://api.covidcast.cmu.edu/epidata/covidcast/?data_source=doctor-visits&signal=smoothed_cli&time_type=day&geo_type=state&time_values=" + weekAgo + "&geo_value=" + state
            let sessionDrVisits = URLSession(configuration: .default)
            
            sessionDrVisits.dataTask(with: URL(string: urlDrVisits)!) { (data, _, err) in
                
                if err != nil{
                    print((err?.localizedDescription)!)
                    return
            }
                print("here is the data", data ?? "")

                let jsonResultDrVisit = try! JSONDecoder().decode(PercentageResult.self, from: data!)
                for resultDrVisit in jsonResultDrVisit.epidata {
                    print("deaths", resultDrVisit.value)
                    self.drvisit = resultDrVisit
                }
                
        }
        .resume()
        }
        else {
            self.drvisit = nil
        }
        
        
    }
    
    private func parseHTML(html : String)
       {
           var textResult = ""

           do
           {
               let doc: Document = try SwiftSoup.parse(html)
               let els: Elements = try doc.select("table.table")
               var count = 0
               
               for link: Element in els.array() {
                   let linkHref: String = try link.attr("tr")
                   let linkText: String = try link.text()
                   textResult = linkText
                   }
               
//               let range = NSRange(location: 0, length: textResult.utf16.count)
//               let regex = try! NSRegularExpression(pattern: "[a-z]")
//               print(regex.firstMatch(in: textResult, options: [], range: range) != nil)
               let matched = matches(for: "no. [0-9].[0-9]", in: textResult)
               print(matched)
               print("Yo did we get results here???", textResult)
               
               if let firstMatch = matched.first {
                   //just dropping characters lmao...
                   let rtNum = String(firstMatch.dropFirst(4))
                   print("found it: \(rtNum)")
                   self.rtNumber = rtNum
               } else {
                 print("nothing found :(")
               }
               
           }
           catch Exception.Error(let type, let message)
           {
               print(type)
               print(message)
           }
           catch
           {
               print("SwiftSoup parsing data error!")
           }
          
           print("All good!")
       }
    
    func matches(for regex: String, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func getHeight(value: Int, height: CGFloat)->CGFloat{
        
        if self.greatest != 0 {
            let converted = CGFloat(value) / CGFloat(self.greatest)
            return converted * height
        }
        else {
            return 0
        }
    }
    
    func yesterDay() -> String {
        var dayComponent = DateComponents()
        dayComponent.day = -1
        let calendar = Calendar.current
        let nextDay =  calendar.date(byAdding: dayComponent, to: Date())!
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: nextDay)
    }
    
    func yesterdayForAPI() -> String {
        var dayComponent = DateComponents()
        dayComponent.day = -1
        let calendar = Calendar.current
        let nextDay =  calendar.date(byAdding: dayComponent, to: Date())!
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyyMMdd"
//        let formatter1 = DateFormatter()
//        formatter1.locale = .current
//        formatter1.dateFormat = "HH"
//        let timeMerica = formatter1.string(from: nextDay)
//        print(formatter1.string(from: nextDay))
        return formatter.string(from: nextDay)
    }
    
    func weeklyForAPI() -> String {
        var dayComponent = DateComponents()
        dayComponent.day = -7
        let calendar = Calendar.current
        let nextDay =  calendar.date(byAdding: dayComponent, to: Date())!
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: nextDay)
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
        return formatter.string(from: nextDay)
    }
    
    //using this one to get hospitalizations. Slightly lazy but works
    func fourDaysAgoForAPI() -> String {
        var dayComponent = DateComponents()
        dayComponent.day = -4
        let calendar = Calendar.current
        let nextDay =  calendar.date(byAdding: dayComponent, to: Date())!
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: nextDay)
    }
    
    func convertDateFormat(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let newDate = dateFormatter.date(from: date)
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d")
        return dateFormatter.string(from: newDate!)
    }
    
}
