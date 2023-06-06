//
//  HomeView.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userSettings: UserSettingsManager
    
    //temp
    @State private var showGallery = false

    var body: some View {
        VStack {
            //temp
            Button(action: {
                showGallery = true
            }) {
                Text("Open Gallery")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
        }
        .sheet(isPresented: $showGallery) {
            GalleryView().accentColor(userSettings.accentColor.color)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
