import UIKit

//MARK: - Class
class StorageImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    var imageCounts = 0
    var imageArray: [Image]?
    
    // MARK: - outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "PlusCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlusCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        self.imageArray = Manager.shared.loadImages()
//        Manager.shared.loadImageArray()
        debugPrint("Count elements \(Manager.shared.loadImages().count)")
    }
    
    // MARK: - IBActions
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Flow func
    func presentAddImageViewController () {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController else {return}
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - Extension
extension StorageImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Manager.shared.loadImages().count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlusCollectionViewCell", for: indexPath) as? PlusCollectionViewCell else { return UICollectionViewCell() }
            return cell
        }
        if indexPath.row > 0 {
            if let array = self.imageArray {
                cell.configure(with: array[indexPath.item - 1])
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.presentAddImageViewController()
        } else {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SingleViewController") as? SingleViewController else {
                return
            }
            controller.currentIndex = indexPath.item - 1
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.size.width - 10) / 2
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

