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
  
factory Banda.frommMap(Map<String, dynamic> obj) => 
  Banda(
    id:obj['id'],
    nombre: obj['name'],
    votos: obj['votos']
  );
 


}
