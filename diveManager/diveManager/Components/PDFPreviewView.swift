import SwiftUI
import PDFKit
import UIKit

struct PDFPreviewView: View {
    let url: URL

    var body: some View {
        NavigationStack {
            PDFKitView(url: url)
                .edgesIgnoringSafeArea(.all)
                .navigationBarItems(trailing: Button(action: {
                    sharePDF(url: url)
                }) {
                    Image(systemName: "square.and.arrow.up")
                })
                .navigationBarTitle("PDF Preview", displayMode: .inline)
        }
    }

    private func sharePDF(url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            
            var currentViewController = rootViewController
            while let presentedViewController = currentViewController.presentedViewController {
                currentViewController = presentedViewController
            }
            
            currentViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        if let document = PDFDocument(url: url) {
            pdfView.document = document
        }
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {}
}
