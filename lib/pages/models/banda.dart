import 'package:flutter/material.dart';

class Banda {
   String? id;
   String? nombre;
   int? votos;

  Banda({
     this.id,
     this.nombre,
     this.votos,
  });
  
factory Banda.fromMap(Map<String, dynamic> obj) => 
  Banda(
        //original 
    // id:obj['id'],
    // nombre: obj['nombre'],
    // votos: obj['votos']
    //con validacion, lo mismo de arriba pero con validacion
    id    :  obj.containsKey('id') ? obj['id'] : 'sin-id',
    nombre:  obj.containsKey('nombre') ? obj['nombre'] : 'sin-nombre',
    votos :  obj.containsKey('votos') ? obj['votos'] : 'sin-votos'
  );
 


}
