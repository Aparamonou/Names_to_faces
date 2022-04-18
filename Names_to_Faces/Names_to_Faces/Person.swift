//
//  Peerson.swift
//  Names_to_Faces
//
//  Created by Alex Paramonov on 29.03.22.
//

import UIKit

class Person: NSObject, NSCoding {
    
     
    
     var name: String
     var image: String
     
     init(name: String, image: String){
          self.name = name
          self.image = image
     }
     
     required init(coder aDecoder: NSCoder) {
          name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
          image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
     }
     
     func encode(with Acoder: NSCoder) {
          Acoder.encode(name, forKey: "name")
          Acoder.encode(image, forKey: "image")
     }
     
    
     
    
}
