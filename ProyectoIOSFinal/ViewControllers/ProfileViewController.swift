//
//  ProfileViewController.swift
//  ProyectoIOSFinal
//
//  Created by Victor Mollocondo Asillo on 3/07/22.
//
import FirebaseStorage
import SDWebImage
import FirebaseDatabase
import FirebaseCore
import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()

    @IBOutlet weak var imagen: UIImageView!
    
    var user:Users?
    var imagenID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    func mostrarAlerta(titulo:String, mensaje:String,accion:String){
        let alerta = UIAlertController(title:titulo, message: mensaje, preferredStyle: .alert)
        let btnCancelOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCancelOK)
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func ElegirImagen(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagen.image = image
        
         let imagenesFolder = Storage.storage().reference().child("imagenes")
                let imagenData = imagen.image?.jpegData(compressionQuality: 0.50)
                let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
                    cargarImagen.putData(imagenData!, metadata: nil) { (metadata, error) in
                    if error != nil{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelve a intentarlo.", accion: "Aceptar")
                        print("Ocurrio un error al subir la imagen: \(String(describing: error))")
                    }else{
                        cargarImagen.downloadURL(completion: { (url, error) in
                            guard url != nil else{
                                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener la informacion de la imagen", accion: "Cancelar")
                                print("Ocurrio un error al obtener la informacion de la imagen \(String(describing: error))")
                                return
                            }
                    })
                }
                    }
        imagen.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
    

                                                 
