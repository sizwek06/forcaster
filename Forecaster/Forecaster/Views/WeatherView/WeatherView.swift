//
//  WeatherView.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import SwiftUICore
import SwiftUI

struct WeatherView: View {
    @ScaledMetric(relativeTo: .headline) var dynamicHeaderSize = 65
    @ScaledMetric(relativeTo: .headline) var dynamicSubheaderSize = 40
    @ScaledMetric(relativeTo: .title) var dynamicTitleSize = 29
    @ScaledMetric(relativeTo: .body) var dynamicTextSize = 15
    
    var body: some View {
        ScrollView {
            VStack(spacing: -10) {
                // Background header Image
                ZStack {
                    Image("sea_sunnypng")
                        .resizable()
                        .frame(height: UIScreen.main.bounds.width - 20 / 5)
                        .padding(.leading, -1)
                    
                    // To remove the Orange line next to shoreline
                    VStack {
                        Text("25°")
                            .font(.custom(WeatherConstants.sfProRounded,
                                          size: dynamicHeaderSize))
                            .foregroundColor(.white)
                        Text("Sunny".uppercased())
                            .font(.custom(WeatherConstants.sfProRounded,
                                          size: dynamicSubheaderSize))
                            .foregroundColor(.white)
                    }
                }
                
                // Header of current
                VStack(spacing: 5) {
                    HStack(spacing: 5) {
                        Spacer()
                        currentText(degrees: "19°", text: "min")
                            .padding(.leading, -15)
                        currentText(degrees: "19°", text: "Current")
                            .padding(.leading, 65)
                        currentText(degrees: "19°", text: "max")
                            .padding(.leading, 75)
                    }
                    .background(.currentStack)
                    .frame(width: WeatherConstants.returnDesiredWidth())
                    
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 1)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                createForecastCell(day: "Tuesday", condition: "clear", degrees: "25°")
                createForecastCell(day: "Wednesday", condition: "clear", degrees: "25°")
                createForecastCell(day: "Thursday", condition: "clear", degrees: "25°")
                createForecastCell(day: "Friday", condition: "clear", degrees: "25°")
                createForecastCell(day: "Saturday", condition: "clear", degrees: "25°")
            }
            .frame(width: WeatherConstants.returnDesiredWidth())
            .background(.currentStack)
        }
        .edgesIgnoringSafeArea(.all)
        .background(.currentStack)
    }
    
    func currentText(degrees: String, text: String) -> some View {
        VStack(alignment: .center) {
            Text(degrees)
                .font(.custom(WeatherConstants.sfProRegular,
                              size: dynamicTextSize))
                .foregroundColor(.white)
            Text(text)
                .font(.custom(WeatherConstants.sfProRegular,
                              size: dynamicTextSize))
                .foregroundColor(.white)
        }
        .padding(.bottom, 10)
        .padding(.top, 5)
        .frame(minWidth: 75, alignment: .leading)
    }
    
    func createForecastCell(day: String, condition: String, degrees: String) -> some View {
        HStack {
            Text(day)
                .multilineTextAlignment(.leading)
                .font(.custom(WeatherConstants.sfProRegular,
                              size: dynamicTextSize))
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(minWidth: 100, alignment: .leading)
            Image(condition)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .padding(.leading, 65)
            Text(degrees)
                .font(.custom(WeatherConstants.sfProRegular,
                              size: dynamicTextSize))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding(.trailing, 10)
                .padding(.leading, 100)
        }
        .background(.currentStack)
    }
    
    func createForecastTable() -> some View {
        List {
            createForecastCell(day: "Tuesday", condition: "clear", degrees: "25°")
            createForecastCell(day: "Wednesday", condition: "clear", degrees: "25°")
            createForecastCell(day: "Thursday", condition: "clear", degrees: "25°")
            createForecastCell(day: "Friday", condition: "clear", degrees: "25°")
            createForecastCell(day: "Saturday", condition: "clear", degrees: "25°")
        }
        .listStyle(.inset)
        .listRowInsets(.init(top: 10, leading: 23, bottom: 0, trailing: 25))
        .listRowSeparator(.hidden)
        .background(.currentStack)
    }
}


#Preview {
    WeatherView()
}
