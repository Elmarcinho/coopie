import 'dart:convert';


SalidaModel salidaModelFromJson(String str) => SalidaModel.fromJson(json.decode(str));

String salidaModelToJson(SalidaModel data) => json.encode(data.toJson());

class SalidaModel {
    String id;
    int cedulaChofer;
    String nombreChofer;
    String fechaHoraSalida;
    int movil;
    bool estado;

    SalidaModel({
        this.id,
        this.cedulaChofer,
        this.nombreChofer,
        this.fechaHoraSalida,
        this.movil,
        this.estado=true,
    });

    factory SalidaModel.fromJson(Map<String, dynamic> json) => SalidaModel(
        id: json["id"],
        cedulaChofer: json["cedulaChofer"],
        nombreChofer: json["nombreChofer"],
        fechaHoraSalida: json["fechaHoraSalida"],
        movil: json["movil"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cedulaChofer": cedulaChofer,
        "nombreChofer": nombreChofer,
        "fechaHoraSalida": fechaHoraSalida,
        "movil": movil,
        "estado": estado,
    };
}
