//
//  FormTextField.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 24/5/25.
//
import SwiftUI

struct FormTextField: View {
    let title: String
    let placeholder: String
    let icon: String
    
    @Binding var text: String
    let contentType: UITextContentType?
    let keyboardType: UIKeyboardType
    let capitalization: TextInputAutocapitalization
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                
                TextField(placeholder, text: $text)
                    .textContentType(contentType)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(capitalization)
                    .autocorrectionDisabled()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
        }
    }
}

#Preview {
    @Previewable @State var text = "cxcarvaj@gmail.com"
    
    FormTextField(title: "Email",
                  placeholder: "Escribe tu correo",
                  icon: "envelope.fill",
                  text: $text,
                  contentType: .emailAddress,
                  keyboardType: .emailAddress,
                  capitalization: .never)
}
