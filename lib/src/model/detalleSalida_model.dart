import 'dart:convert';


DetalleSalidaModel detalleSalidaModelFromJson(String str) => DetalleSalidaModel.fromJson(json.decode(str));

String detalleSalidaModelToJson(DetalleSalidaModel data) => json.encode(data.toJson());

class DetalleSalidaModel {
  String id;
  int cedulaChofer;
  String nombreGeoPunto;
  String fechaHoraSalida;
  String fechaHoraLlegada;
  int movil;


  DetalleSalidaModel({
      this.id,
      this.cedulaChofer,
      this.nombreGeoPunto,
      this.fechaHoraSalida,
      this.fechaHoraLlegada,
      this.movil,
  });

  factory DetalleSalidaModel.fromJson(Map<String, dynamic> json) => DetalleSalidaModel(
      id: json["id"],
      cedulaChofer: json["cedulaChofer"],
      nombreGeoPunto: json["nombreGeoPunto"],
      fechaHoraSalida: json["fechaHoraSalida"],
      fechaHoraLlegada: json["fechaHoraLlegada"],
      movil: json["movil"],
  );

  Map<String, dynamic> toJson() => {
      "id":id,
      "cedulaChofer": cedulaChofer,
      "nombreGeoPunto": nombreGeoPunto,
      "fechaHoraSalida": fechaHoraSalida,
      "fechaHoraLlegada": fechaHoraLlegada,
      "movil": movil,
  };
}
