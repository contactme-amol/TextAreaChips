//
//  ContentView.swift
//  TextAreaChips
//
//  Created by Amol Chaudhari on 21/05/21.
//

import SwiftUI
import MaterialComponents
import UIKit

struct ContentView: View {
    @State var chips = [MDCChipView]()
    var body: some View {
        return VStack {
            VStack {
                ChipView(chips: $chips, fieldPlaceholder: "Type and add tag with space")
                    .frame(width: 350, height: 54, alignment: .center)
            }
            Button("Submit") {
                print(chips.count)
                for tag in chips {
                    print("tag.titleLabel.text: \(tag.titleLabel.text ?? "")")
                }
            }.padding([.top], 80)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ChipView: UIViewRepresentable {
    @Binding var chips: [MDCChipView]
    var fieldPlaceholder: String
    
    func makeUIView(context: Context) -> MDCChipField {
        let chipField = MDCChipField()
        chipField.delegate = context.coordinator
        chipField.textField.placeholderLabel.text = fieldPlaceholder
        chipField.showChipsDeleteButton = true
        chipField.showPlaceholderWithChips = true
        chipField.delimiter = .space
        chipField.textField.delegate = context.coordinator
        chipField.sizeToFit()
        chipField.layer.borderWidth = 1.0
        chipField.layer.borderColor = UIColor.gray.cgColor
        return chipField
    }
    
    
    
    func updateUIView(_ uiView: MDCChipField, context: Context) {
        context.coordinator.componentUpdates = { newSelection in
            self.chips = uiView.chips
        }
    }
    
    typealias UIViewType = MDCChipField;
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UITextFieldDelegate, MDCChipFieldDelegate {
        var componentUpdates: (String) -> () = { _ in }
        
        func updatefocus(textfield: UITextField) {
            textfield.becomeFirstResponder()
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.componentUpdates("")
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        func chipField(_ chipField: MDCChipField, didRemoveChip chip: MDCChipView) {
            self.componentUpdates("")
        }
        
    }
}
