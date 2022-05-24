import UIKit

//MARK: - Class
class AddViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var bottomScrollViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.registerForKeyboardNotifications()
        self.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    // MARK: - IBActions
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseButtonPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        //               imagePicker.sourceType = .camera
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveImageButtonPressed(_ sender: UIButton) {
        self.addImageToArray()
    }
    
    @IBAction func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomScrollViewConstraint.constant = 0
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            bottomScrollViewConstraint.constant = keyboardScreenEndFrame.height + 25
        }
        
        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Flow func
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addImageToArray() {
        guard let image = self.imageView.image else {
            print("Empty image")
            self.showAlert(title: "Error", message: "Need choose image", actionTitles: ["OK"], style: [.default], actions: [nil])
            return
        }
        
        if let image = self.imageView.image {
            if let imageName = Manager.shared.saveImage(image) {
                guard let text = descriptionTextField.text else {return}
                let imageObject = Image(name: imageName, description: text, isFavorite: false)
                Manager.shared.addImage(imageObject)
            }
        }
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "StorageImageViewController") as? StorageImageViewController else {return}
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - Extension
extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.imageView.image = image
        
        guard let image = info[.originalImage] as? UIImage else { return }
        self.imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}


