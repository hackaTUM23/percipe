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
    let isAllergy: Bool
    
    init(name: String, amount: String, imageUrl: String, isAllergy: Bool = false) {
        self.name = name
        self.amount = amount
        self.imageUrl = imageUrl
        self.isAllergy = isAllergy
    }
    
    var color: Color {
        if self.isAllergy {
            .red
        } else {
            .black
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                    }
                    Text(name)
                        .lineLimit(2)
                    //.truncationMode(.tail)
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
                    self.color.opacity(0.0),
                    self.color.opacity(0.4),
                ], startPoint: .top, endPoint: .bottom))
            }
            if self.isAllergy {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.red, lineWidth: 2)
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.red)
                    .font(.title)
                    .padding(10)
            }
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
        .shadow(radius: 10)
    }
}

#Preview {
    HStack {
        IngredientTile(name: "Parsley", amount: "10 g", imageUrl: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3/ingredient/64da29a5796d73553a89656b-a8fa0db5.png")
        IngredientTile(name: "Parsley", amount: "10 g", imageUrl: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3/ingredient/64da29a5796d73553a89656b-a8fa0db5.png", isAllergy: true)
    }
}
