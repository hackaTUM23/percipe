//
//  ProfilePictureView.swift
//  Percipe
//
//  Created by Andreas Resch on 18.11.23.
//

import SwiftUI

struct ProfilePictureView: View {
    var body: some View {
        HStack {
            Image(.carbonara)
                .resizable()
                .frame(width: 90, height: 90)
                .cornerRadius(50)
                .padding(.leading, 4)
                .padding(.top, 4)
            Text("Léon Friedmann")
                .font(.headline)
            Spacer()
        }
    }
}

#Preview {
    ProfilePictureView()
}
