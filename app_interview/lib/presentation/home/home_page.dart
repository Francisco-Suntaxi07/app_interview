import 'package:app_interview/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'home_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel _viewModel;

  //Funcion de una ventana modal para agregar empleado
  Future<void> addEmployeeDialog(BuildContext context) async {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final ciController = TextEditingController();
    final positionController = TextEditingController();
    final departmentController = TextEditingController();
    final signatureController = TextEditingController();

    final newEmployee = await showDialog<EmployeeModel>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Crear Empleado"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: "Nombre"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: "Apellido"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ciController,
                  decoration: const InputDecoration(labelText: "Cédula"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: positionController.text.isNotEmpty
                      ? positionController.text
                      : null,
                  decoration: const InputDecoration(labelText: "Cargo"),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'Supervisor',
                      child: Text('Supervisor'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Líder',
                      child: Text('Líder'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Operario',
                      child: Text('Operario'),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    positionController.text = newValue ?? '';
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: departmentController.text.isNotEmpty
                      ? departmentController.text
                      : null,
                  decoration: const InputDecoration(labelText: "Área"),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'Financiera',
                      child: Text('Financiera'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Talento Humano',
                      child: Text('Talento Humano'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Operaciones',
                      child: Text('Operaciones'),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    departmentController.text = newValue ?? '';
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: signatureController,
                  decoration: const InputDecoration(labelText: "Firma"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                final employee = EmployeeModel(
                  id: null,
                  nombre: firstNameController.text,
                  apellido: lastNameController.text,
                  cedula: ciController.text,
                  cargo: positionController.text,
                  area: departmentController.text,
                  firma: signatureController.text,
                );
                Navigator.of(ctx).pop(employee);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
    if (newEmployee != null) {
      await _viewModel.addEmployee(newEmployee);
      _viewModel.fetchEmployees();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Empleado agregado exitosamente!'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> confirmDelete(BuildContext context, HomeViewModel viewModel, int userId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content: const Text("¿Estás seguro de que deseas eliminar este empleado?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false), // No eliminar
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true), // Confirmar eliminación
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await viewModel.deleteEmployee(userId);
      _viewModel.fetchEmployees();
    }
  }


  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    _viewModel.fetchEmployees();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 50.0),
                child: Image.asset('assets/user.png', fit: BoxFit.cover, height: 100),
              ),
              const Text("Nómina empleados",
                  style: TextStyle(fontSize: 25.0)
              ),
              Container(
                width: 200.0,
                padding: const EdgeInsets.only(top: 30.0,bottom: 15.0),
                child:ElevatedButton(
                  onPressed: (){
                    addEmployeeDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Crear empleado",
                          style: TextStyle(color: Colors.white)
                      ),
                      Icon(Icons.person_add, size: 30.0, color: Colors.white,),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Consumer<HomeViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.employees.isEmpty) {
                      return const Center(child: Text("No hay empleados"));
                    }
                    return ListView.builder(
                      itemCount: viewModel.employees.length,
                      itemBuilder: (context, index) {
                        final employee = viewModel.employees[index];
                        return EmployeeCard(
                          employee: employee,
                          onDelete: () async {
                           await confirmDelete(context, viewModel, employee.id!);
                          },
                        );
                      },
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}


class EmployeeCard extends StatelessWidget {
  final EmployeeModel employee;
  final VoidCallback onDelete;
  const EmployeeCard({
    required this.employee,
    required this.onDelete,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( "NOMBRES: ${employee.nombre} ${employee.apellido}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("ID: ${employee.id}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "CEDULA: ${employee.cedula}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),
            Text(
              "AREA: ${employee.area}",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "CARGO: ${employee.cargo}",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Firma: ${employee.firma}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text("Eliminar",
                      style: TextStyle(color: Colors.white)
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}
