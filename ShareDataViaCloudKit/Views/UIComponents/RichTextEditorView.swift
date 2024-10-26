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
    private let buttonsStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextView()
        setupButtons()
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
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ])
    }
    
    private func setupButtons() {
        // Create custom button configuration
        var config = UIButton.Configuration.bordered()
        config.cornerStyle = .medium
        config.baseForegroundColor = .blue
        config.background.backgroundColor = .clear
        
        // Bold button
        let boldButton = UIButton(configuration: config)
        boldButton.setTitle("B", for: .normal)
        boldButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        boldButton.addTarget(self, action: #selector(toggleBold), for: .touchUpInside)
        
        // Italic button
        let italicButton = UIButton(configuration: config)
        italicButton.setTitle("I", for: .normal)
        italicButton.titleLabel?.font = .italicSystemFont(ofSize: 16)
        italicButton.addTarget(self, action: #selector(toggleItalic), for: .touchUpInside)
        
        // Setup stack view
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 10
        buttonsStackView.alignment = .center
        
        // Add buttons to stack view
        buttonsStackView.addArrangedSubview(boldButton)
        buttonsStackView.addArrangedSubview(italicButton)
        
        // Add stack view to main view
        addSubview(buttonsStackView)
        
        // Configure constraints
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            boldButton.widthAnchor.constraint(equalToConstant: 40),
            boldButton.heightAnchor.constraint(equalToConstant: 30),
            italicButton.widthAnchor.constraint(equalToConstant: 40),
            italicButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupCharacterCountLabel() {
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        characterCountLabel.font = UIFont.systemFont(ofSize: 14)
        characterCountLabel.textColor = UIColor.gray
        characterCountLabel.text = "0/\(characterLimit)"
        addSubview(characterCountLabel)
        
        NSLayoutConstraint.activate([
            characterCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            characterCountLabel.centerYAnchor.constraint(equalTo: buttonsStackView.centerYAnchor)
        ])
    }
    
    private func toggleAttribute(_ attribute: NSAttributedString.Key, bold: Bool = false, italic: Bool = false) {
        let selectedRange = textView.selectedRange
        guard selectedRange.length > 0 else { return }
        
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        let currentAttributes = attributedText.attributes(at: selectedRange.location, longestEffectiveRange: nil, in: selectedRange)
        
        let currentFont = (currentAttributes[.font] as? UIFont) ?? UIFont.systemFont(ofSize: 16)
        let currentFontSize = currentFont.pointSize
        
        let fontDescriptor = currentFont.fontDescriptor
        var traits = fontDescriptor.symbolicTraits
        
        if bold {
            if traits.contains(.traitBold) {
                traits.remove(.traitBold)
            } else {
                traits.insert(.traitBold)
            }
        }
        
        if italic {
            if traits.contains(.traitItalic) {
                traits.remove(.traitItalic)
            } else {
                traits.insert(.traitItalic)
            }
        }
        
        if let newDescriptor = fontDescriptor.withSymbolicTraits(traits) {
            let newFont = UIFont(descriptor: newDescriptor, size: currentFontSize)
            attributedText.addAttribute(.font, value: newFont, range: selectedRange)
        }
        
        textView.attributedText = attributedText
        textView.selectedRange = selectedRange
    }
    
    @objc private func toggleBold() {
        toggleAttribute(.font, bold: true)
    }
    
    @objc private func toggleItalic() {
        toggleAttribute(.font, italic: true)
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
            HStack {
                Text("Cancel")
                    .foregroundStyle(.blue)
                Spacer()
                Text("New Little Note")
                    .font(.headline)
                Spacer()
                Text("Send").foregroundStyle(.blue)
            }
            Spacer()
            RichTextEditor()
                .frame(height: 300)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(20)
            Spacer()
        }
        .padding()
    }
}

#Preview { ContentView() }
