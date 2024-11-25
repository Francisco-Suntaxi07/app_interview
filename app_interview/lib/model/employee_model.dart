class EmployeeModel {
  final int? id;
  final String nombre;
  final String apellido;
  final String cedula;
  final String cargo;
  final String area;
  final String firma;

  EmployeeModel({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.cedula,
    required this.cargo,
    required this.area,
    required this.firma,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'cedula': cedula,
      'cargo': cargo,
      'area': area,
      'firma': firma,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      cedula: map['cedula'],
      cargo: map['cargo'],
      area: map['area'],
      firma: map['firma'],
    );
  }
}