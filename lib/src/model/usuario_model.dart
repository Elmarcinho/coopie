import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) => UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
    String id;
    int cedula;
    String nombreUsuario;

    UsuarioModel({
        this.id,
        this.cedula,
        this.nombreUsuario=' ',
    });

    factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        id: json["id"],
        cedula: json["cedula"],
        nombreUsuario: json["nombreUsuario"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cedula": cedula,
        "nombreUsuario": nombreUsuario,
    };
}
