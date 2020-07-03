import 'dart:convert';


MarcajeModel marcajeModelFromJson(String str) => MarcajeModel.fromJson(json.decode(str));

String marcajeModelToJson(MarcajeModel data) => json.encode(data.toJson());

class MarcajeModel {
    int cedula;
    int movil;
    int atraso;
    String chofer;
    String fecha;
    String fechaHoraSalida;
    String fechaHoraMarcaje;
    String fechaHoraLlegada;
    String geo;
    String puntoMarcaje;
    String timestamp;

    MarcajeModel({
        this.cedula,
        this.movil,
        this.atraso,
        this.chofer,
        this.fecha,
        this.fechaHoraSalida,
        this.fechaHoraMarcaje,
        this.fechaHoraLlegada,
        this.geo,
        this.puntoMarcaje,
        this.timestamp
    });

    factory MarcajeModel.fromJson(Map<String, dynamic> json) => MarcajeModel(
        cedula: json["cedula"],
        movil: json["movil"],
        atraso: json["atraso"],
        chofer: json["chofer"],
        fecha: json["fecha"],
        fechaHoraSalida: json["fechaHoraSalida"],
        fechaHoraMarcaje: json["fechaHoraMarcaje"].toDate().toString(),
        fechaHoraLlegada: json["fechaHoraLlegada"],
        geo: json["geo"],
        puntoMarcaje: json["puntoMarcaje"],
        timestamp: json["timestamp"].toDate().toString()
    );

    Map<String, dynamic> toJson() => {
        "cedula": cedula,
        "movil": movil,
        "atraso": atraso,
        "chofer": chofer,
        "fecha": fecha,
        "fechaHoraSalida": fechaHoraSalida,
        "fechaHoraMarcaje": fechaHoraMarcaje,
        "fechaHoraLlegada" : fechaHoraLlegada,
        "geo": geo,
        "puntoMarcaje": puntoMarcaje,
        "timestamp": timestamp
    };
}

