

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';

String lbnMsg = "Usando o GPS";
String MsgCoordernada ="Sem Valor";
String MsgcoordenadaAtualizada ="Sem Valor";


class Principal extends StatefulWidget {
  const Principal({ Key? key }) : super(key: key);

  @override
_PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {

var location =  new Location();
 late LocationData _locationData ;

 bool _serviceEnabled = false;
 PermissionStatus _permissionGranted  = PermissionStatus.denied;

void serviceStatus() async {
  _serviceEnabled = await location.serviceEnabled();
  if(!_serviceEnabled){
    _serviceEnabled = await location.requestService();
    if(!_serviceEnabled){
      return;
    }
  }
}

void obterPermissao() async{
  _permissionGranted = await location.hasPermission();
  if(_permissionGranted == PermissionStatus.denied){
    _permissionGranted = await location.requestPermission();
     if(_permissionGranted != PermissionStatus.granted){
      return;
     }
  }
}

Future obterLocalizacao() async{
  _locationData = await location.getLocation();
  return _locationData;
}

@override
void initState(){
  super.initState();
  location.changeSettings(interval: 300);
  location.onLocationChanged.listen((LocationData currentLocation) {
    setState(() {
      MsgcoordenadaAtualizada = currentLocation.latitude.toString()+
      "\n"
      +currentLocation.longitude.toString();
      print(currentLocation);
    });
   });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Localização"),
              backgroundColor: Colors.blueGrey,),
    body: Container(padding: EdgeInsets.all(30),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(lbnMsg),
        ElevatedButton(onPressed:(){ serviceStatus();
         if(_permissionGranted == PermissionStatus.denied){
          obterPermissao();
         }else{
          obterLocalizacao().then((value){
            setState(() {
              MsgCoordernada = _locationData.latitude.toString()+"\n"+_locationData.longitude.toString();
            });
        });
        }


        }, child: Text("Click para obter coordenada")),
        Text(MsgCoordernada),
        Text("Atualizado"),
        Text(MsgcoordenadaAtualizada),

               
    ]),),
    
    );
  }
}