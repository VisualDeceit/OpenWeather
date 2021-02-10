//
//  LoginFormController.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 01.12.2020.
//

import UIKit
import FirebaseAuth



class LoginFormController: UIViewController {

    @IBOutlet var loginInput: UITextField!
    @IBOutlet var passwordInput: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var loginTitleView: UILabel!
    @IBOutlet var passwordTitleView: UILabel!
    @IBOutlet var titleView: UILabel!
    @IBOutlet var logInButton: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle!
    
    @IBAction func signinButtonPressed(_ sender: Any) {
        guard
              let email = loginInput.text,
              let password = passwordInput.text,
            email.count > 0,
            password.count > 0
        else {
            showAlert(title: "Error", message: "Invalid user data entered")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) {[weak self] (user, error) in
            if let error = error, user == nil {
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
//                else {
//                self?.performSegue(withIdentifier: "LogIn", sender: nil)
//            }
        }
        
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .alert)
        alert.addTextField { (textEmail) in
            textEmail.placeholder = "Enter your email"
            textEmail.textContentType = .emailAddress
        }
        alert.addTextField { (textPassword) in
            textPassword.placeholder = "Enter your password"
            textPassword.textContentType = .newPassword
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let emailField = alert.textFields?[0],
                  let passwordField = alert.textFields?[1],
                  let email = emailField.text,
                  let password = passwordField.text
            else { return }
            Auth.auth().createUser(withEmail: email, password: password) {[weak self] (user, error) in
                if let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
                else {
                    Auth.auth().signIn(withEmail: email, password: password)
                }
            }
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
       
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard checkUserData() else {
            showAlert(title: "Error", message: "Invalid user data entered")
            loginInput.text = ""
            passwordInput.text = ""
            return false
        }
        return true

    }
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        do {
            try  Auth.auth().signOut()
        }
        catch (let error) {
            print(error)
        }
    }
    
    // MARK: - Проверка авторизации
    func checkUserData() -> Bool {
        guard
            let login = loginInput.text,
            let password = passwordInput.text
        else {
            return false
        }
        return login == "" && password == ""
    }

    // MARK:  - Показ alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // Присваиваем его UIScrollVIew
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //прячем бар
        navigationController?.navigationBar.isHidden = true
        
        animateTitlesAppearing()
        animateTitleAppearing()
        animateFieldsAppearing()
        animateAuthButton()
        
        handle = Auth.auth().addStateDidChangeListener{ [weak self] (auth, user) in
            if user != nil {
                print(user)
                self?.performSegue(withIdentifier: "LogIn", sender: nil)
                self?.loginInput.text = nil
                self?.passwordInput.text = nil
            }
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        navigationController?.navigationBar.isHidden = false
        
        Auth.auth().removeStateDidChangeListener(handle)
        }

    
// Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    @objc func hideKeyboard() {
            self.scrollView?.endEditing(true)
        }

    
  
    func animateTitlesAppearing() {
        let offset = view.bounds.width
        loginTitleView.transform = CGAffineTransform(translationX: -offset, y: 0)
        passwordTitleView.transform = CGAffineTransform(translationX: offset, y: 0)
        
        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: .curveEaseOut,
                       animations: {
                           self.loginTitleView.transform = .identity
                           self.passwordTitleView.transform = .identity
                       },
                       completion: nil)
    }
    
    func animateTitleAppearing() {
        self.titleView.transform = CGAffineTransform(translationX: 0,
                                                     y: -self.view.bounds.height/2)
        
        UIView.animate(withDuration: 1,
                       delay: 1,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.titleView.transform = .identity
                       },
                       completion: nil)
    }
    
    
    func animateFieldsAppearing() {
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        fadeInAnimation.duration = 1
        fadeInAnimation.beginTime = CACurrentMediaTime() + 1
        fadeInAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        fadeInAnimation.fillMode = CAMediaTimingFillMode.backwards
        
        self.loginInput.layer.add(fadeInAnimation, forKey: nil)
        self.passwordInput.layer.add(fadeInAnimation, forKey: nil)
    }

    
    func animateAuthButton() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime() + 1
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.logInButton.layer.add(animation, forKey: nil)
    }

    
    
    


}
