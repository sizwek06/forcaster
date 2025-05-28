//
//  ShortLoaderView.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/25.
//

import SwiftUI

struct ShortLoaderAlertView: View {
    
    @State private var isRotating = 0.0
    
    var body: some View {
        VStack {
            Spacer()
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white)
                VStack {
                    Image("openWeatherLogo")
                        .resizable()
                        .frame(width: 100,
                               height: 100)
                    ProgressView()
                        .progressViewStyle(.circular)
                        .rotationEffect(.degrees(isRotating))
                        .scaleEffect(1.5)
                        .tint(.red)
                    Text(WeatherConstants.loaderText)
                        .font(.headline)
                        .frame(width: UIScreen.main.bounds.width / 2,
                               height: UIScreen.main.bounds.height / 20,
                               alignment: .center)
                        .foregroundStyle(.red)
                }
            }
            .frame(minHeight: 150, idealHeight: 182, maxHeight: 200)
            .padding()
            Spacer()
            
        }.background(VisualEffectView(effect: UIBlurEffect(style: .dark))
            .edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    ShortLoaderAlertView()
}

