//
//  ShareView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 9/17/24.
//


import SwiftUI
import LinkPresentation
import UniformTypeIdentifiers
import StoreKit

class ActivityItemProvider: NSObject, UIActivityItemSource {
    let url: URL

    init(url: URL) {
        self.url = url
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return url
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return url
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.originalURL = url
        metadata.url = url
        metadata.title = "Shape Shuffle"
        return metadata
    }
}

struct ShareView: UIViewControllerRepresentable {
    let url: URL
    @ObservedObject var userPersistedData = UserPersistedData()

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityItems = [ActivityItemProvider(url: url)]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if completed {
                print("Share completed successfully!")
                if !userPersistedData.hasShared {
                    userPersistedData.incrementBalance(amount: 5)
                    userPersistedData.hasShared = true
                }
            } else {
                print("User canceled the share.")
            }
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                DispatchQueue.main.async {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
        }

        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
            context: UIViewControllerRepresentableContext<ShareView>) {
        // No updates needed
    }
}
