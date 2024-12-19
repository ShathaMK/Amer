//
//  GIFImage.swift
//

import SwiftUI
import UIKit
import ImageIO

struct GIFImage: UIViewRepresentable {
    let name: String

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(imageView)
        
        // Add constraints for the imageView to respect the container size
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let imageView = uiView.subviews.first as? UIImageView else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            if let gifImage = UIImage.gif(name: name) {
                DispatchQueue.main.async {
                    imageView.image = gifImage
                    imageView.startAnimating()
                }
            }
        }
    }
}

extension UIImage {
    static func gif(name: String) -> UIImage? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "gif"),
              let data = try? Data(contentsOf: url) else {
            print("GIF named \(name) not found.")
            return nil
        }
        
        let source = CGImageSourceCreateWithData(data as CFData, nil)
        let frameCount = CGImageSourceGetCount(source!)
        
        var images: [UIImage] = []
        var duration: TimeInterval = 0
        
        for i in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source!, i, nil) else { continue }
            images.append(UIImage(cgImage: cgImage))
            
            let frameProperties = CGImageSourceCopyPropertiesAtIndex(source!, i, nil) as? [String: Any]
            let gifProperties = frameProperties?[kCGImagePropertyGIFDictionary as String] as? [String: Any]
            let frameDuration = gifProperties?[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0.1
            duration += frameDuration
        }
        
        return UIImage.animatedImage(with: images, duration: duration)
    }
}


#Preview {
    Onboarding_1()
}
