//
//  LoginViewController.swift
//  BookSearch
//
//  Created by Mac 17 on 23/06/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseAnalytics

class loginViewController: UIViewController {

    @IBOutlet weak var ControlSegmento: UISegmentedControl!
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var botonLogin: UIButton!
    
    var iconClick = false
    let imageicon = UIImageView()
    let person = Users()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent("Prueba de inicio", parameters: ["message":"Integración con Analytics"])
       
    }
    
    // Configurando casos para el boton segmento

    @IBAction func btnSegmento(_ sender: Any) {
        let control = ControlSegmento.selectedSegmentIndex
        switch control {
        case 0:
            botonLogin.setTitle("Iniciar Sesion", for: .normal)
        case 1:
            botonLogin.setTitle("Registrar Usuario", for: .normal)
        default:
            print("error control Segmento")
        }
    }
    
    //  Boton de Login para inicio de sesión y registro
    
    @IBAction func btnLogin(_ sender: Any) {
        let opcion = ControlSegmento.selectedSegmentIndex
        switch  opcion {
        case 0:
            Auth.auth().signIn(withEmail: txtUsuario.text!, password: txtPassword.text!) {
                (user, error) in
                print("Intentando Iniciar Sesion")
                if error != nil{
                    print("Se presento el siguiente error: \(String(describing: error))")
                    let alerta = UIAlertController(title: "Error", message: "Usuario Incorrecto, por favor intentelo de nuevo o cree uno en registrp", preferredStyle: .alert)
                    let btnCerrar = UIAlertAction(title: "Cerrar", style: .default, handler: { (UIAlertAction) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alerta.addAction(btnCerrar)
                    self.present(alerta, animated: true, completion: nil)
                }else{
                    print("Inicio de Sesion Exitoso")
                    self.person.uid = user!.user.uid
                    self.person.name = user!.user.email
                    self.performSegue(withIdentifier: "inicioSegue", sender: self.person)
                }
            }
        case 1:
            Auth.auth().createUser(withEmail: self.txtUsuario.text!, password: self.txtPassword.text!, completion: { (user, error) in
                print("Intentando crear un usuario")
                if error != nil {
                    print("Se presento el siguiente error al crear el usuario: \(String(describing: error))")
                    let alerta = UIAlertController(title: "Error", message: "Se produjo un error al crear el usuario.", preferredStyle: .alert)
                    let btnCerrar = UIAlertAction(title: "Cerrar", style: .default, handler: { (UIAlertAction) in
                    })
                    alerta.addAction(btnCerrar)
                    self.present(alerta, animated: true, completion: nil)
                }else{
                    print("El usuario fue creado satisfactoriamente")
                Database.database().reference().child("Usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                    
                    let alerta = UIAlertController(title: "Creacion de Usuario", message: "Usuario: \(self.txtUsuario.text!) se creo perfectamente.", preferredStyle: .alert)
                    let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
                        self.person.uid = user!.user.uid
                        self.person.name = user!.user.email
                        self.performSegue(withIdentifier: "inicioSegue", sender: self.person)
                    })
                    alerta.addAction(btnOK)
                    self.present(alerta, animated: true, completion: nil)
                }
            })
        default:
            print("Error!")
        }
    }
    //implementando la func para imagen
    

}

