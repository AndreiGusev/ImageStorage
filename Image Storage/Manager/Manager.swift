import Foundation
import UIKit

class Manager {
    
    static let shared = Manager()
    
    private init() {}
    
    func saveImage(_ image: UIImage) -> String? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = UUID().uuidString
        guard let fileURL = documentsDirectory?.appendingPathComponent(fileName),
              let imageData = image.jpegData(compressionQuality: 1) else { return nil }
                if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let error {
                print(error.localizedDescription)
                return nil
            }
        }
        
        do {
            try imageData.write(to: fileURL)
            return fileName
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadImage() -> [Image] {
        guard let image = UserDefaults.standard.value([Image].self, forKey: "imageArray") else { return [] }
        return image
    }
    func loadImageByName(fileName: String) -> UIImage? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: fileURL.path)
        return image
    }

    func loadImages() -> [Image] {
        guard let images = UserDefaults.standard.value([Image].self, forKey: "imageArray") else { return [] }
        return images
    }
    
    func addImage(_ image: Image) {
        var images = self.loadImages()
        images.append(image)
        UserDefaults.standard.set(encodable: images, forKey: "imageArray")
        
    }
    
}
