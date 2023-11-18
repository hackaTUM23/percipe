//
//  JustifiedText.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import Foundation
import UIKit
import SwiftUI

struct JustifiedLabel: UIViewRepresentable {
    var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textView.textAlignment = .justified
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
        let size = uiView.systemLayoutSizeFitting(
            CGSize(
                width: proposal.width ?? UIView.layoutFittingCompressedSize.width,
                height: UIView.layoutFittingCompressedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
        return proposal.replacingUnspecifiedDimensions(by: size)
    }
}
//struct JustifiedLabel: UIViewRepresentable {
//    var text: String
//    var width: CGFloat
//    
//    init(_ text: String, width: CGFloat) {
//        self.text = text
//        self.width = width
//    }
//    
//    func makeUIView(context: Context) -> UILabel {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.textAlignment = .justified
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.preferredMaxLayoutWidth = width
//        return label
//    }
//    
//    func updateUIView(_ uiView: UILabel, context: Context) {
//        uiView.text = text
//    }
//    
//    typealias UIViewType = UILabel
//}
