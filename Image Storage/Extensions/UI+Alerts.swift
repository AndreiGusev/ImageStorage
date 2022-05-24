import UIKit

extension UIViewController {
    
    public func showAlert(title: String?,
                          message: String?,
                          actionTitles: [String?],
                          style: [UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)?],
                          preferredActionIndex: Int? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: style[index], handler: actions[index])
            alert.addAction(action)
        }
        if let preferredActionIndex = preferredActionIndex { alert.preferredAction = alert.actions[preferredActionIndex] }
        self.present(alert, animated: true, completion: nil)
    }
    
    public func addAlert(title: String?,
                         message: String?,
                         style: UIAlertController.Style = UIAlertController.Style.alert,
                         okButtonHandler: ((UIAlertAction) -> ())? = nil,
                         cancelButtonHandler: ((UIAlertAction) -> ())? = nil,
                         titleButtonThree: String? = nil,
                         threeButtonHandler: ((UIAlertAction) -> ())? = nil,
                         threeButtonStyle: UIAlertAction.Style = UIAlertAction.Style.default) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: okButtonHandler)
        alert.addAction(okButton)
        if cancelButtonHandler != nil {
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelButtonHandler)
            alert.addAction(cancelButton)
        }
        if threeButtonHandler != nil {
            let threeButton = UIAlertAction(title: titleButtonThree, style: threeButtonStyle, handler: threeButtonHandler)
            alert.addAction(threeButton)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showActionSheetAlert() {
        let alert = UIAlertController(title: "Hello", message: "Alert is cool, you should try it", preferredStyle: .actionSheet)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        
        let destructive = UIAlertAction(title: "Kill", style: .destructive, handler: nil)
        alert.addAction(destructive)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
