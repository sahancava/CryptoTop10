//
//  ImagePicker.swift
//  CryptoTop10
//
//  Created by sahanc on 12.08.2023.
//

import Foundation
import SwiftUI

class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate {
    var parent: DocumentPicker?
    
    init(_ parent: DocumentPicker) {
        self.parent = parent
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        parent?.selectedURL = urls.first
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedURL: URL?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    typealias Coordinator = DocumentPickerCoordinator
}

struct PDFUploadContentView: View {
    @State private var showDocumentPicker: Bool = false
    @State private var selectedURL: URL?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Upload PDF File")
                .font(.largeTitle)
            
            if let url = selectedURL {
                Text(url.lastPathComponent)
                    .foregroundColor(.blue)
                    .underline()
            } else {
                Text("No PDF selected")
                    .foregroundColor(.gray)
            }
            
            Button(action: {
                showDocumentPicker.toggle()
            }) {
                Text("Select PDF")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .sheet(isPresented: $showDocumentPicker, content: {
            DocumentPicker(selectedURL: $selectedURL)
        })
    }
}
