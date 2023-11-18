//
//  IngredientTile.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct IngredientTile: View {
    let name: String
    let amount: String?
    let imageUrl: String
    let isAllergy: Bool
    let large: Bool
    
    init(name: String, amount: String?, imageUrl: String, isAllergy: Bool = false, large: Bool = false) {
        self.name = name
        self.amount = amount
        self.imageUrl = imageUrl
        self.isAllergy = isAllergy
        self.large = large
    }
    
    var color: Color {
        if self.isAllergy {
            .red
        } else {
            .black
        }
    }
    
    var width: Double {
        if self.large {
            200
        } else {
            100
        }
    }
    
    var height: Double {
        if self.large {
            150
        } else {
            150
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                Spacer()
                VStack(alignment: self.large ? .center : .leading) {
                    HStack {
                        Spacer()
                    }
                    Text(name)
                        .lineLimit(3)
                        .truncationMode(.middle)
                        .padding(.top, 30)
                        .fontWeight(.semibold)
                    if let amount = amount {
                        Text(amount)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                .padding(.bottom, 5)
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
                    .truncationMode(.middle)
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.red)
                    .font(.title)
                    .padding(10)
            }
        }
        .foregroundColor(.white)
        .frame(width: self.width, height: self.height)
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
    VStack {
        HStack {
            IngredientTile(name: "Parsley", amount: "10 g", imageUrl: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3/ingredient/64da29a5796d73553a89656b-a8fa0db5.png")
            IngredientTile(name: "Parsley", amount: "10 g", imageUrl: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3/ingredient/64da29a5796d73553a89656b-a8fa0db5.png", isAllergy: true)
            IngredientTile(name: "Parsley", amount: nil, imageUrl: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3/ingredient/64da29a5796d73553a89656b-a8fa0db5.png")
        }
        IngredientTile(name: "Parsley", amount: "10 g", imageUrl: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3/ingredient/64da29a5796d73553a89656b-a8fa0db5.png", large: true)
    }
}
