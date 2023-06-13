//
//  AboutView.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//

import SwiftUI

struct AboutView: View {
    let developerName = "Pieceowater"
    let appDescription = String(format: NSLocalizedString("about_appdescription", comment: ""))

    let githubURL = URL(string: "https://github.com/pieceowater")!
    let linkedinURL = URL(string: "https://www.linkedin.com/in/pieceowater/")!
    let tiktokURL = URL(string: "https://www.tiktok.com/@yurymid")!
    let resumeURL = URL(string: "https://pieceowater.github.io/resume/")!

    var body: some View {
        VStack {
            Image("MoneyGuard")
                .resizable()
                .frame(width: 65, height: 65)
                .cornerRadius(13)
                .shadow(color: .black.opacity(0.2), radius: 4)
            Text("app_name")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            Text(appDescription)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Link("\(String(format: NSLocalizedString("about_developed", comment: ""))) \(developerName)", destination: resumeURL)
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 20)

            Spacer()
            HStack {
                Link("GitHub", destination: githubURL)
                Spacer()
                Link("LinkedIn", destination: linkedinURL)
                Spacer()
                Link("TikTok", destination: tiktokURL)
            }
            .padding(.top, 20)
            .padding()
        }
        .navigationBarTitle("menu_actions_about")
        .padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
