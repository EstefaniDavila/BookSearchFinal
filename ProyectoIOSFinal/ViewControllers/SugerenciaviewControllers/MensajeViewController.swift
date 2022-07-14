//
//  MensajeViewController.swift
//  ProyectoIOSFinal
//
//  Created by Victor Mollocondo Asillo on 4/07/22.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class MensajeViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mensaje: UITextField!
    @IBOutlet weak var elegir: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        elegir.isEnabled = false
    }
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func elgirTapped(_ sender: Any) {
        self.elegir.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("sugerencias")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
            cargarImagen.putData(imagenData!, metadata: nil) {(metadata, error) in
            if error != nil {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexión a internet y vuelva a intentarlo.", accion: "Aceptar")
                self.elegir.isEnabled = true
                print("ocurrió un error al subir la imagen: \(error)")
                return
            }else{
                cargarImagen.downloadURL(completion: { (url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener información de imagen", accion: "Cancelar")
                        self.elegir.isEnabled = true
                        print("Ocurrió un error al obtener información de imagen \(error)")
                        return
                    }
                    self.performSegue(withIdentifier: "segueElegir", sender: url?.absoluteString)
                })
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegir.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        let alerta = UIAlertController(title: titulo, message: mensaje,
                                       preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.mensaje = mensaje.text!
        siguienteVC.imagenID = imagenID
        
    }
        

}
