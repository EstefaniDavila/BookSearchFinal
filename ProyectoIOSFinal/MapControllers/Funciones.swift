//
//  Funciones.swift
//  ProyectoIOSFinal
//
//  Created by Victor Mollocondo Asillo on 3/07/22.
//

import Foundation
import CoreData
import UIKit

func crearLibreria(xnombre:String, ximagenNombre:String){
    let context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    let libros = Libros(context: context)
    libros.nombre = xnombre
    libros.imagenNombre = ximagenNombre
}


func agregarLibrerias(){
    crearLibreria(xnombre: "San Francisco Libreria", ximagenNombre: "1")
    crearLibreria(xnombre: "Ordoñes", ximagenNombre: "2")
    crearLibreria(xnombre: "Luciano", ximagenNombre: "2")
    crearLibreria(xnombre: "Libreria Melgar", ximagenNombre: "2")
    crearLibreria(xnombre: "Biblioteca Santa Teresa", ximagenNombre: "2")
    crearLibreria(xnombre: "Libreria Ormeño", ximagenNombre: "2")
    crearLibreria(xnombre: "Pierola", ximagenNombre: "2")
    crearLibreria(xnombre: "Alvarez Thomas", ximagenNombre: "1")
    crearLibreria(xnombre: "San Lazaro Libreria", ximagenNombre: "1")
    crearLibreria(xnombre: "Libreria Sillar", ximagenNombre: "1")
    crearLibreria(xnombre: "Libreria Moral", ximagenNombre: "1")
    crearLibreria(xnombre: "Biblioteca La Marina", ximagenNombre: "1")
    crearLibreria(xnombre: "Tienda Sucre", ximagenNombre: "1")
    crearLibreria(xnombre: "Libros Palacio Viejo", ximagenNombre: "1")
    crearLibreria(xnombre: "Biblioteca Municipal", ximagenNombre: "1")
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func obtenerLibrerias()-> [Libros]{
    let context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    do{
        let libros = try context.fetch(Libros.fetchRequest()) as! [Libros]
        if libros.count == 0{
            agregarLibrerias()
            return obtenerLibrerias()
        }
        return libros
    }catch{}
    return []
}

func obtenerLibreriasAtrapados() -> [Libros]{
    let context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    let queryConWhere = Libros.fetchRequest() as NSFetchRequest<Libros>
    queryConWhere.predicate = NSPredicate(format: "atrapado == %@", NSNumber(value: true))
    do{
        let libros = try context.fetch(queryConWhere) as [Libros]
        return libros
    }catch{}
    return[]
}

func obtenerLibreriasNoAtrapados() -> [Libros]{
    let context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    let queryConWhere = Libros.fetchRequest() as NSFetchRequest<Libros>
    queryConWhere.predicate = NSPredicate(format: "atrapado == %@", NSNumber(value: false))
    do{
        let libros = try context.fetch(queryConWhere) as [Libros]
        return libros
    }catch{}
    return[]
}

