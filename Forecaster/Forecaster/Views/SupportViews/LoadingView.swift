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
        VStack(alignment: .center) {
            Image("openWeatherLogo")
                .resizable()
                .frame(width: 200,
                       height: 200)
            ProgressView()
                .progressViewStyle(.circular)
                .rotationEffect(.degrees(isRotating))
                .scaleEffect(2)
                .tint(.red)
                .padding(.top, 25)
            Text("Forecaster v\(Bundle.main.buildVersionNumber ?? "1.01.01")")
                .font(.headline)
                .padding(.top, 150)
                .frame(width: UIScreen.main.bounds.width - 20,
                       height: UIScreen.main.bounds.height / 20,
                       alignment: .center)
                .foregroundStyle(.red)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
