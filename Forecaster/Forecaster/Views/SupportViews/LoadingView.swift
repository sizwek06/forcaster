//
//  LoadingView.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/22.
//

import SwiftUI

struct LoadingView: View {
    
    @State private var isRotating = 0.0
    
    var body: some View {
        VStack {
            Image("openWeatherLogo")
                .resizable()
                .frame(width: 200,
                       height: 200)
            ProgressView()
                .progressViewStyle(.circular)
                .rotationEffect(.degrees(isRotating))
                .scaleEffect(2)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
