//
//  SwipeView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import Foundation
import SwiftUI
import CoreHaptics

let dislikeColors = [Color(hex: "ff6560"), Color(hex: "f83770")]
let likeColors = [Color(hex: "6ceac5"), Color(hex: "16dba1")]

enum SwipeAction{
    case swipeLeft, swipeRight, doNothing
}

struct SwipeView: View {
    var appModel = Model.shared
    @Binding var recipes: [RecipeCardModel]
    @State var swipeAction: SwipeAction = .doNothing
    //Bool: true if it was a like (swipe to the right
    var onSwiped: (RecipeCardModel, Bool) -> ()
    
    var body: some View {
        VStack{
            VStack{
                ZStack{
                    Text("No more recipes").font(.title3).fontWeight(.medium).foregroundColor(Color(UIColor.systemGray)).multilineTextAlignment(.center)
                    ForEach(recipes.indices, id: \.self){ index  in
                        let model: RecipeCardModel = recipes[index]
                        
                        if(index == recipes.count - 1){
                            SwipeableCardView(model: model, swipeAction: $swipeAction, onSwiped: performSwipe)
                        } else if(index == recipes.count - 2){
                            SwipeCardView(model: model)
                        }
                    }
                }
            }
            .padding()
            HStack{
                Spacer()
                GradientOutlineButton(action:{swipeAction = .swipeLeft}, iconName: "multiply", colors: dislikeColors)
                Spacer()
                GradientOutlineButton(action: {swipeAction = .swipeRight}, iconName: "heart", colors: likeColors)
                Spacer()
            }
            .padding(.bottom)
        }
    }
    
    private func performSwipe(userProfile: RecipeCardModel, hasLiked: Bool){
        removeTopItem()
        if (hasLiked) {
            appModel.addMatch(id: userProfile.id)
        }
        onSwiped(userProfile, hasLiked)
    }
    
    private func removeTopItem(){
        recipes.removeLast()
    }
    
    
}

//Swipe functionality
struct SwipeableCardView: View {
    
    private let screenWidthLimit = UIScreen.main.bounds.width * 0.5
    
    let model: RecipeCardModel
    @State private var dragOffset = CGSize.zero
    @Binding var swipeAction: SwipeAction
    
    var onSwiped: (RecipeCardModel, Bool) -> ()
    
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        SwipeCardView(model: model)
            .overlay(
                HStack{
                    Text("Yummy")
                        .font(.largeTitle)
                        .bold()
                        .foregroundGradient(colors: likeColors)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(LinearGradient(gradient: .init(colors: likeColors), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 4)
                        )
                        .rotationEffect(.degrees(-30)).opacity(getLikeOpacity())
                    Spacer()
                    Text("Yuck").font(.largeTitle)
                        .bold()
                        .foregroundGradient(colors: dislikeColors)
                        .padding().overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(LinearGradient(gradient: .init(colors: dislikeColors),
                                                       startPoint: .topLeading,
                                                       endPoint: .bottomTrailing), lineWidth: 4)
                        ).rotationEffect(.degrees(30)).opacity(getDislikeOpacity())
                    
                }.padding(.top, 45).padding(.leading, 20).padding(.trailing, 20)
                ,alignment: .top)
            .offset(x: self.dragOffset.width,y: self.dragOffset.height)
            .rotationEffect(.degrees(self.dragOffset.width * -0.06), anchor: .center)
            .simultaneousGesture(DragGesture(minimumDistance: 0.0).onChanged{ value in
                self.dragOffset = value.translation
            }.onEnded{ value in
                performDragEnd(value.translation)
                print("onEnd: \(value.location)")
            })
            .onChange(of: swipeAction, perform: { newValue in
                if newValue != .doNothing {
                    performSwipe(newValue)
                }
                
            })
    }
    
    private func performSwipe(_ swipeAction: SwipeAction){
        withAnimation(.linear(duration: 0.3)){
            if(swipeAction == .swipeRight){
                self.dragOffset.width += screenWidthLimit * 2
            } else if(swipeAction == .swipeLeft){
                self.dragOffset.width -= screenWidthLimit * 2
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onSwiped(model, swipeAction == .swipeRight)
        }
        self.swipeAction = .doNothing
    }
    
    private func performDragEnd(_ translation: CGSize){
        let translationX = translation.width
        if(hasLiked(translationX)){
            withAnimation(.linear(duration: 0.3)){
                self.dragOffset = translation
                self.dragOffset.width += screenWidthLimit
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onSwiped(model, true)
            }
        } else if(hasDisliked(translationX)){
            withAnimation(.linear(duration: 0.3)){
                self.dragOffset = translation
                self.dragOffset.width -= screenWidthLimit
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onSwiped(model, false)
            }
        } else{
            withAnimation(.default){
                self.dragOffset = .zero
            }
        }
    }
    
    private func hasLiked(_ value: Double) -> Bool{
        let ratio: Double = dragOffset.width / screenWidthLimit
        return ratio >= 1
    }
    
    private func hasDisliked(_ value: Double) -> Bool{
        let ratio: Double = -dragOffset.width / screenWidthLimit
        return ratio >= 1
    }
    
    private func getLikeOpacity() -> Double{
        let ratio: Double = dragOffset.width / screenWidthLimit;
        if(ratio >= 1){
            return 1.0
        } else if(ratio <= 0){
            return 0.0
        } else {
            return ratio
        }
    }
    
    private func getDislikeOpacity() -> Double{
        let ratio: Double = -dragOffset.width / screenWidthLimit;
        if(ratio >= 1){
            return 1.0
        } else if(ratio <= 0){
            return 0.0
        } else {
            return ratio
        }
    }
}

//Card design
struct SwipeCardView: View {
    let model: RecipeCardModel
    
    @State private var currentImageIndex: Int = 0
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        ZStack(alignment: .bottom){
            GeometryReader{ geometry in
                AsyncImage(
                    url: URL(string: "https://img.hellofresh.com/w_1024,q_auto,f_auto,c_limit,fl_lossy/hellofresh_s3\(model.pictures[currentImageIndex] ?? "")"),
                    content: { image in
                        image
                            .centerCropped()
                    },
                    placeholder: {
                        Image(.whitePlaceholder)
                            .centerCropped()
                    }
                )
                .gesture(DragGesture(minimumDistance: 0).onEnded({ value in
                    if value.translation.equalTo(.zero){
                        if(value.location.x <= geometry.size.width/2){
                            showPrevPicture()
                        } else {
                            showNextPicture()
                        }
                    }
                }))
            }
            
            VStack{
                if(model.pictures.count > 1){
                    HStack{
                        ForEach(0..<model.pictures.count, id: \.self){ index in
                            Rectangle().frame(height: 3).foregroundColor(index == currentImageIndex ? .white : .gray).opacity(index == currentImageIndex ? 1 : 0.5)
                        }
                    }
                    .padding(.top, 6)
                    .padding(.leading)
                    .padding(.trailing)
                }
                Spacer()
                VStack{
                    HStack(alignment: .firstTextBaseline){
                        Text(model.name).font(.largeTitle).fontWeight(.semibold)
                        Spacer()
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(LinearGradient(colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.4),
                ], startPoint: .top, endPoint: .bottom))
            }
            .frame(maxWidth: .infinity)
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(0.7, contentMode: .fit)
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .onAppear {
            prepareHaptics()
        }
    }
    
    
    private func showNextPicture(){
        if currentImageIndex < model.pictures.count - 1 {
            currentImageIndex += 1
            hapticFeedback()
        }
    }
    
    private func showPrevPicture(){
        if currentImageIndex > 0 {
            currentImageIndex -= 1
            hapticFeedback()
        }
    }
    
    func hapticFeedback() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
}
