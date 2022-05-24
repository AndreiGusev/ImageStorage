import UIKit
import SwiftyKeychainKit

//MARK: - Class
class LoginViewController: UIViewController {
    
    // MARK: - Properties
    let keychain = Keychain(service: "keychain.service")
    let key = KeychainKey<String>(key: "secretKey")

    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var bottomScrollViewConstraint: NSLayoutConstraint!
    
    var isNew = false {
        didSet {
            if isNew {
                self.showCreateNewuserViewController()
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForKeyboardNotifications()
        self.passwordField.isSecureTextEntry = true
        self.hideKeyboardWhenTappedAround()
        self.scrollView.contentInsetAdjustmentBehavior = .never
                    
        if UserDefaults.standard.value(forKey: "password") == nil {
            self.isNew = true
        }
    }
    
    // MARK: - IBActions
    @IBAction func showPasswordBtnPressed(_ sender: UIButton) {
        self.passwordField.isSecureTextEntry = !passwordField.isSecureTextEntry
    }
    
    @IBAction func logInBtnPressed(_ sender: Any) {
        if comparePassword() {
            self.showStorageView()
        } else {
            showAlert(title: "Error", message: "wrong password", actionTitles: ["OK"], style: [.default], actions: [nil])
        }
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
    
    func comparePassword () -> Bool {
        if let password = try? self.keychain.get(self.key) {
            if password == passwordField.text {
                return true
            } else {
                return false
            }
        }
        return false
    }

    func showCreateNewuserViewController() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewUserViewController") as? CreateNewUserViewController else {return}
               self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showStorageView () {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "StorageImageViewController") as? StorageImageViewController else {return}
               self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - Extension
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}


