//
//  GalleryView.swift
//  MoneyGuard
//
//  Created by yury mid on 07.06.2023.
//

import SwiftUI

struct GalleryView: View {
    @Binding var selectedIcon: Icons?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("gallery_heading")
                .font(.title)
                .padding()
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(Icons.allCases, id: \.self) { icon in
                        Button(action: {
                            selectedIcon = icon
                            giveHapticFeedback()
                        }) {
                            Image(icon.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .padding(8)
                                .background(selectedIcon == icon ? Color.accentColor.opacity(0.2) : Color.clear)
                                .cornerRadius(15)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            
            Button(action: {
                submitSelectedIcon()
            }) {
                Text("btn_submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
    }
    
    func submitSelectedIcon() {
        if let selectedIcon = selectedIcon {
        } else {
            // No icon selected
            selectedIcon = .default
        }
        // Dismiss the view
        presentationMode.wrappedValue.dismiss()
    }
}

//struct GalleryView_Previews: PreviewProvider {
//    static var previews: some View {
//        GalleryView()
//    }
//}
