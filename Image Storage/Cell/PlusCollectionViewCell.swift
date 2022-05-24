import UIKit

class PlusCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func instanceFromNib() -> PlusCollectionViewCell {
        guard let view = UINib(nibName: "PlusCollectionViewCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as? PlusCollectionViewCell else { return PlusCollectionViewCell() }
        return view
    }
    
}
