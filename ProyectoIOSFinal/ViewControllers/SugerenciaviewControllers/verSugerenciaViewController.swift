//
//  verSugerenciaViewController.swift
//  ProyectoIOSFinal
//
//  Created by Victor Mollocondo Asillo on 4/07/22.
//

import UIKit
import SDWebImage
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class verSugerenciaViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblMensaje: UILabel!
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblMensaje.text = "mensaje : " + snap.mensaje
        imageView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        Database.database().reference().child("Usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
        
        Storage.storage().reference().child("sugerencias").child("\(snap.imagenID).jpg").delete{ (error ) in
            print("Se elimino la imagen correctamente")
        }
    }

}
