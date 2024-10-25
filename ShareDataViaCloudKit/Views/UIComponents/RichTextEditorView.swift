//
//  RichTextEditorView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 25/10/24.
//

import SwiftUI
import UIKit

class RichTextEditorView: UIView, UITextViewDelegate {
    private let textView = UITextView()
    private let characterLimit = 280
    private let characterCountLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextView()
        setupToolbar()
        setupCharacterCountLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = true
        textView.backgroundColor = UIColor.clear
        addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30) // Leave space for the counter
        ])
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let boldButton = UIBarButtonItem(title: "Bold", style: .plain, target: self, action: #selector(toggleBold))
        let italicButton = UIBarButtonItem(title: "Italic", style: .plain, target: self, action: #selector(toggleItalic))
        
        toolbar.items = [boldButton, italicButton]
        
        textView.inputAccessoryView = toolbar
    }
    
    private func setupCharacterCountLabel() {
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        characterCountLabel.font = UIFont.systemFont(ofSize: 14)
        characterCountLabel.textColor = UIColor.gray
        characterCountLabel.text = "0/\(characterLimit)"
        addSubview(characterCountLabel)
        
        NSLayoutConstraint.activate([
            characterCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            characterCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    @objc private func toggleBold() {
        toggleAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16))
    }
    
    @objc private func toggleItalic() {
        toggleAttribute(.font, value: UIFont.italicSystemFont(ofSize: 16))
    }
    
    @objc private func toggleUnderline() {
        toggleAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue)
    }
    
    private func toggleAttribute(_ attribute: NSAttributedString.Key, value: Any) {
        let selectedRange = textView.selectedRange
        guard selectedRange.length > 0 else { return }
        
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        let currentAttributes = attributedText.attributes(at: selectedRange.location, longestEffectiveRange: nil, in: selectedRange)
        
        if currentAttributes[attribute] == nil {
            attributedText.addAttribute(attribute, value: value, range: selectedRange)
        } else {
            attributedText.removeAttribute(attribute, range: selectedRange)
        }
        
        textView.attributedText = attributedText
        textView.selectedRange = selectedRange
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let characterCount = textView.text.count
        characterCountLabel.text = "\(characterCount)/\(characterLimit)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= characterLimit
    }
}

struct RichTextEditor: UIViewRepresentable {
    func makeUIView(context: Context) -> RichTextEditorView {
        return RichTextEditorView()
    }

    func updateUIView(_ uiView: RichTextEditorView, context: Context) {
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            RichTextEditor()
                .frame(height: 300)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
        }
        .padding()
    }
}

#Preview { ContentView() }
