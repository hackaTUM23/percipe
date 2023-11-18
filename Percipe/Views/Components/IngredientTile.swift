//
//  IngredientTile.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct IngredientTile: View {
    let name: String
    let amount: String
    let imageUrl: String
    
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                }
                Text(name)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(.top, 30)
                    .fontWeight(.semibold)
                Text(amount)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(.bottom, 5)
            }
            .padding(.horizontal, 5)
            .frame(maxWidth: .infinity)
            .background(LinearGradient(colors: [
                Color.black.opacity(0.0),
                Color.black.opacity(0.4),
            ], startPoint: .top, endPoint: .bottom))
        }
        .foregroundColor(.white)
        .frame(width: 100, height: 150)
        .background(
            AsyncImage(
                url: URL(string: imageUrl),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                },
                placeholder: {
                    ProgressView()
                }
            )
        )
        .cornerRadius(6)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    IngredientTile(name: "Parsley", amount: "10 g", imageUrl: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3/ingredient/64da29a5796d73553a89656b-a8fa0db5.png")
}
