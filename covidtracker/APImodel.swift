//
//  APImodel.swift
//  covidtracker
//
//  Created by Giovanni Zinzi on 1/11/22.
//

import SwiftUI

struct Daily: Identifiable{
    var id : Int
    var day : String
    var cases : Int
}

struct MainData: Decodable{
    var geo_value : String?
    var signal : String?
    var source : String?
    var geo_type : String?
    var time_type : String?
    var time_value : Int
    var direction : String?
    var issue : Int
    var lag : Int
    var missing_value : Int
    var missing_stderr : Int
    var missing_sample_size : Int
    //VALUE IS THE IMPORTANT ONE FOR THIS RESULT
    var value : Int
    var stderr : String?
    var sample_size : String?
}

struct PercentageData: Decodable{
    var geo_value : String?
    var signal : String?
    var source : String?
    var geo_type : String?
    var time_type : String?
    var time_value : Int
    var direction : String?
    var issue : Int
    var lag : Int
    var missing_value : Int
    var missing_stderr : Int
    var missing_sample_size : Int
    //VALUE IS THE IMPORTANT ONE FOR THIS RESULT
    var value : Double
    var stderr : String?
    var sample_size : String?
}

struct MyState : Decodable{
    var timeline : [String: [String : Int]]
}

struct Country : Decodable{
    var cases : [String : Int]
}

struct Result: Decodable {
    var epidata: [MainData]
}

struct PercentageResult: Decodable {
    var epidata: [PercentageData]
}

struct Indicator : UIViewRepresentable {
    @Binding var isAnimating: Bool

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.color = UIColor.systemBlue
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        
    }
    
}
