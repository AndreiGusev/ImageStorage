import UIKit
import SwiftyKeychainKit

//MARK: - Class
class CreateNewUserViewController: UIViewController {
    
    // MARK: - Properties
    let keychain = Keychain(service: "keychain.service")
    let key = KeychainKey<String>(key: "secretKey")
    
    // MARK: - IBOutlets
    @IBOutlet weak var bottomScrollViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.registerForKeyboardNotifications()
        self.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    // MARK: - IBActions
    @IBAction func enterBtnPressed(_ sender: Any) {
        if checkPasswords() {
            try? self.keychain.set(self.passwordField.text!, for: self.key)
            UserDefaults.standard.setValue(passwordField.text, forKey: "password")
            enterBtn()
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
    
    func checkPasswords() -> Bool {
        if passwordField.text != repeatPasswordField.text || passwordField.text == "" {
            self.showAlert(title: "Error", message: "Password do not match", actionTitles: ["OK"], style: [.default], actions: [nil])
        } else {
            return true
        }
        return true
    }
    
    func enterBtn () {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
