import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with image: Image) {
        self.imageView.contentMode = .scaleToFill
        self.imageView.image = Manager.shared.loadImageByName(fileName: image.name)
    }

}
