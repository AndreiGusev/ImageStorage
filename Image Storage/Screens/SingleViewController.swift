import UIKit

//MARK: - Class
class SingleViewController: UIViewController {
    
    // MARK: - Lets/vars
    var imageArray = [Image]()
    var currentIndex = 0
    var isImageModified = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomScrlViewConstr: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollView.contentInsetAdjustmentBehavior = .never
        self.imageArray = Manager.shared.loadImages()
        self.setup()
        self.imageView.contentMode = .scaleAspectFit
    }
    
    // MARK: - IBActions
    @IBAction func backButtonPressed(_ sender: Any) {
        self.saveChanges()
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "StorageImageViewController") as? StorageImageViewController else {return}
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        self.imageArray[currentIndex].isFavorite = !self.imageArray[currentIndex].isFavorite
        self.setFavoriteButton()
    }
    
    @IBAction func comentFieldEditingChanged(_ sender: UITextField) {
        self.imageArray[currentIndex].description = sender.text ?? ""
        self.isImageModified = true
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        let okActionHandler: ((UIAlertAction) -> Void) = { (action) in
            debugPrint("Delete")
            
            if self.imageArray.count > 1 {
                self.imageArray.remove(at: self.currentIndex)
                let array = self.imageArray
                UserDefaults.standard.set(encodable: array, forKey: "imageArray")
                self.imageView.image = Manager.shared.loadImageByName(fileName: self.imageArray[self.imageArray.count - 1].name)
                self.currentIndex = self.imageArray.count - 1
                self.loadDataImage()
            }
            else if self.imageArray.count == 1 {
                self.imageArray.remove(at: self.currentIndex)
                let array = self.imageArray
                UserDefaults.standard.set(encodable: array, forKey: "imageArray")
                self.imageView.image = UIImage(named: "There are no image")
                self.leftButton.isEnabled = false
                self.rightButton.isEnabled = false
                self.favoriteButton.isEnabled = false
                self.favoriteButton.setImage(UIImage(named: "LikeIsNotTrue"), for: .normal)
                self.removeButton.isEnabled = false
                self.textField.text = ""
                self.textField.isEnabled = false
            }
        }
        
        let cancelActionHandler: ((UIAlertAction) -> Void) = {(action) in
            print("Do not Delete")
        }
        
        self.showAlert(title: "Delete image", message: "Are you shure?", actionTitles: ["DELETE", "CANCEL"], style: [.destructive, .cancel], actions: [okActionHandler,cancelActionHandler], preferredActionIndex: 1)
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        self.moveSlideLeft()
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        self.moveSlideRight()
    }
    
    @IBAction func leftSwipeDetected(_ sender: UISwipeGestureRecognizer) {
        self.moveSlideRight()
    }
    
    @IBAction func rightSwipeDetected(_ sender: UISwipeGestureRecognizer) {
        self.moveSlideLeft()
    }
    
    @IBAction func tapRecognized(_ sender: UITapGestureRecognizer) {
        self.zoomImage()
    }
    
    @IBAction func removeZoomedImageView(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            sender.view?.frame = self.imageView.frame
        }) { (_) in
            sender.view?.removeFromSuperview()
        }
    }
    
    @IBAction func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomScrlViewConstr.constant = 0
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            bottomScrlViewConstr.constant = keyboardScreenEndFrame.height + 25
        }
        
        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Flow func
    func zoomImage() {
        let zoomedImageView = UIImageView()
        zoomedImageView.frame = self.view.frame
        zoomedImageView.contentMode = .scaleAspectFit
        zoomedImageView.clipsToBounds = true
        zoomedImageView.image = self.imageView.image
        zoomedImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeZoomedImageView(_:)))
        zoomedImageView.addGestureRecognizer(tap)
        self.view.addSubview(zoomedImageView)
        
        UIView.animate(withDuration: 0.3) {
            zoomedImageView.frame = self.view.bounds
            zoomedImageView.backgroundColor = .black
        }
    }
    
    func saveChanges() {
        if self.isImageModified {
            let images = self.imageArray
            UserDefaults.standard.set(encodable: images, forKey: "imageArray")
        }
    }
    
    func setup() {
        if self.imageArray.isEmpty {
            self.favoriteButton.isHidden = true
            self.leftButton.isHidden = true
            self.rightButton.isHidden = true
            self.descriptionTextField.isHidden = true
            return
        }
        
        self.setupImage()
        self.setupSwipeSettings()
    }
    
    func setupImage() {
        self.loadImage(self.imageView)
        self.loadDataImage()
    }
    
    func loadDataImage() {
        self.descriptionTextField.text = self.imageArray[self.currentIndex].description
        self.setFavoriteButton()
    }
    
    func setFavoriteButton() {
        if self.imageArray[currentIndex].isFavorite {
            self.favoriteButton.setImage(UIImage(named: "LikeIsTrue"), for: .normal)
        } else {
            self.favoriteButton.setImage(UIImage(named: "LikeIsNotTrue"), for: .normal)
        }
        self.saveChanges()
    }
    
    func setupSwipeSettings() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeDetected(_:)))
        leftSwipe.direction = .left
        self.imageView.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeDetected(_:)))
        rightSwipe.direction = .right
        self.imageView.addGestureRecognizer(rightSwipe)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapRecognized(_:)))
        self.imageView.addGestureRecognizer(tap)
        
    }
    
    func loadImage(_ imageView: UIImageView) {
        imageView.contentMode = .scaleAspectFill
        if let image = Manager.shared.loadImageByName(fileName: self.imageArray[self.currentIndex].name) {
            imageView.image = image
        }
    }
    
    func moveSlideLeft() {
        self.downCurrentIndex()
        let newImageView = self.createImageView(x: -2 * self.imageView.frame.size.width)
        self.runAnimate(newImageView, finish: 2 * self.imageView.frame.size.width)
    }
    
    func moveSlideRight() {
        self.upCurrentIndex()
        let newImageView = self.createImageView(x: 2 * self.imageView.frame.size.width)
        self.runAnimate(newImageView, finish: -2 * self.imageView.frame.size.width)
    }
    
    func createImageView(x: CGFloat) -> UIImageView {
        let newImageView = UIImageView()
        
        newImageView.frame = CGRect(x: x,
                                    y: 0,
                                    width: self.imageView.frame.size.width,
                                    height: self.imageView.frame.size.height)
        newImageView.contentMode = .scaleAspectFit
        self.loadImage(newImageView)
        self.imageView.addSubview(newImageView)
        
        return newImageView
    }
    
    func runAnimate(_ newImageView: UIImageView, finish: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            newImageView.frame.origin.x += finish
        }) { (_) in
            self.imageView.image = newImageView.image
            newImageView.removeFromSuperview()
            self.loadDataImage()
        }
    }
    
    func upCurrentIndex() {
        if self.currentIndex == self.imageArray.count - 1 {
            self.currentIndex = 0
        } else {
            self.currentIndex += 1
        }
    }
    
    func downCurrentIndex() {
        if self.currentIndex == 0 {
            self.currentIndex = self.imageArray.count - 1
        } else {
            self.currentIndex -= 1
        }
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

extension SingleViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}



