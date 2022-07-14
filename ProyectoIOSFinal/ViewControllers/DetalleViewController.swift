//
//  ComprandoViewController.swift
//  ProyectoIOSFinal
//
//  Created by Victor Mollocondo Asillo on 1/07/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class DetalleViewController: UIViewController {

    @IBOutlet weak var NombreLibro: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var PrecioLibro: UILabel!
    @IBOutlet weak var comprar: UIButton!
    var producto:Accion? = nil
    var usuarios:[Users] = []
    var usuario = Users()
    
    func MostrarImagen(ruta:String) {
        if let url = URL(string: ruta){
            do{
                let data = try Data(contentsOf: url)
                self.imagen.image = UIImage(data: data)
            }catch let err{
                print("error: \(err)")
            }
        }
    }
    @IBAction func comprarProducto(_ sender: Any) {
        let compra = ["Producto": NombreLibro.text, "Precio": PrecioLibro.text]
        Database.database().reference().child("Usuarios").child(Auth.auth().currentUser!.uid).child("compras").childByAutoId().setValue(compra)
        print("usuario\(usuario.uid)\(usuario.email)")
        
        let alerta = UIAlertController(title: "Compra Exitosa", message: "Su compra se Realizo correctamente. Gracias!", preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "Aceptar", style: .default, handler: {(UIAlertAction) in
            
        })
        alerta.addAction(btnOk)
        self.present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func verMapas(_ sender: Any) {
        performSegue(withIdentifier: "verMapas", sender: nil)
    }
    

    
    override func viewDidLoad() {
            super.viewDidLoad()

            MostrarImagen(ruta: producto!.image)
            NombreLibro.text = producto?.titulo
            PrecioLibro.text = producto?.precio
            Database.database().reference().child("Usuarios").observe(DataEventType.childAdded, with: {(snapshot) in print(snapshot)
                self.usuario.email = (snapshot.value as! NSDictionary)["email" ] as! String
                self.usuario.uid = snapshot.key
                self.usuarios.append(self.usuario)
            })

        }
    
}
