import 'dart:convert';

GeoVallaModel geoVallaModelFromJson(String str) => GeoVallaModel.fromJson(json.decode(str));

String geoVallaModelToJson(GeoVallaModel data) => json.encode(data.toJson());

class GeoVallaModel {
    String id;
    String nombre;
    String geo;
    int radio;
    String minuto;

    GeoVallaModel({
        this.id,
        this.nombre,
        this.geo,
        this.radio,
        this.minuto,
    });

    factory GeoVallaModel.fromJson(Map<String, dynamic> json) => GeoVallaModel(
        id    : json["id"],
        nombre: json["nombre"],
        geo   : json["geo"],
        radio : json["radio"],
        minuto: json["minuto"],
    );

    Map<String, dynamic> toJson() => {
        "id"    : id,
        "nombre": nombre,
        "geo"   : geo,
        "radio" : radio,
        "minuto": minuto,
    };
}