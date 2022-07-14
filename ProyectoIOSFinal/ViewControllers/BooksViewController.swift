//
//  TiendaViewController.swift
//  ProyectoIOSFinal
//
//  Created by Victor Mollocondo Asillo on 1/07/22.
//

import UIKit

class BooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var tablaProductos: UITableView!
    @IBOutlet weak var textNombreProducto: UITextField!
    @IBOutlet weak var btnBuscar: UIButton!
    @IBOutlet weak var btnCompras: UIBarButtonItem!
    @IBOutlet weak var btnCerrarSesión: UIBarButtonItem!
    
    var accion = [Accion]()
    var usuario: Users? = nil
    var rutaa = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaProductos.delegate = self
        tablaProductos.dataSource = self
        
        let rutaa = "http://localhost:3000/Accion"
        CargarlibrosAccion(ruta: rutaa){
            self.tablaProductos.reloadData()
        }
    }
    
    @IBAction func verAccion(_ sender: Any) {
    }
    
    func CargarlibrosAccion(ruta:String, completed: @escaping () -> ()){
        let url = URL(string: ruta)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil{
                do{
                    self.accion = try JSONDecoder().decode([Accion].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("Error en JSON el error: \(error)")
                    print("data cancino::\(response!)")
                }
            }
        }.resume()
    }
    
    
    @IBAction func buscarProducto(_ sender: Any) {
        let ruta = "http://localhost:3000/Accion?"
        let nombre = textNombreProducto.text!
        let url = ruta + "nombre_like=\(nombre)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        
        if nombre.isEmpty{
            let ruta = "http://localhost:3000/Accion/"
            self.CargarlibrosAccion(ruta: ruta){
                self.tablaProductos.reloadData()
            }
        }else{
            CargarlibrosAccion(ruta: crearURL){
                if self.accion.count <= 0{
                    self.mostrarAlerta(titulo: "Error", mensaje: "No se encontraron coincidencias para: \(nombre)", accion: "cancel")
                }else{
                    self.tablaProductos.reloadData()
                }
            }
        }
    }
    
    func mostrarAlerta(titulo:String, mensaje:String, accion:String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnOK)
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func CerrarSesion(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        print("Se ha cerrado sesión")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(accion[indexPath.row].titulo)"
        cell.detailTextLabel?.text = "Precio: \(accion[indexPath.row].precio)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let libros = accion[indexPath.row]
        performSegue(withIdentifier: "comprandoSegue", sender: libros)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "comprandoSegue"){
            let siguienteVC = segue.destination as! DetalleViewController
            siguienteVC.producto = sender as? Accion
        }else{
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ruta = "http://localhost:3000/Accion/"
        CargarlibrosAccion(ruta: ruta){
            self.tablaProductos.reloadData()
        }
    }
    
    
    @IBAction func elegidos(_ sender: Any) {
        performSegue(withIdentifier: "segueEscogido", sender: nil)
    }
    
    
    @IBAction func profile(_ sender: Any) {
        performSegue(withIdentifier: "seguePerfil", sender: nil)
    }
    
}
