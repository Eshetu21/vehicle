import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'services.dart';

class EditVehicle extends StatefulWidget {
  final Map<String, dynamic> vehicle;
  const EditVehicle({super.key, required this.vehicle});

  @override
  State<EditVehicle> createState() => _EditVehicleState();
}

class _EditVehicleState extends State<EditVehicle> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabaseService = SupabaseService();

  late TextEditingController _nameController;
  late TextEditingController _statusController;
  late TextEditingController _locationController;
  late TextEditingController _fuelLevelController;
  late TextEditingController _batteryLevelController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.vehicle["name"]);
    _statusController = TextEditingController(text: widget.vehicle["status"]);
    _locationController =
        TextEditingController(text: widget.vehicle["location"]);
    _fuelLevelController =
        TextEditingController(text: widget.vehicle["fuel_level"].toString());
    _batteryLevelController =
        TextEditingController(text: widget.vehicle["battery_level"].toString());
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final status = _statusController.text;
      final location = _locationController.text;

      final fuelLevel = double.tryParse(_fuelLevelController.text) ?? 0.0;
      final batteryLevel = double.tryParse(_batteryLevelController.text) ?? 0.0;

      final updatedVehicleData = {
        'name': name,
        'status': status,
        'location': location,
        'fuel_level': fuelLevel,
        'battery_level': batteryLevel,
      };

      final vehicleId = widget.vehicle['id'].toString();

      await _supabaseService.addOrUpdateVehicle(vehicleId, updatedVehicleData);
      Fluttertoast.showToast(
        msg: "Vehicle updated successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Vehicle"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(
                controller: _nameController,
                labelText: "Vehicle Name",
                hintText: "Enter vehicle name",
              ),
              _buildTextFormField(
                controller: _statusController,
                labelText: "Status",
                hintText: "Enter vehicle status",
              ),
              _buildTextFormField(
                controller: _locationController,
                labelText: "Location",
                hintText: "Enter location",
              ),
              _buildTextFormField(
                controller: _fuelLevelController,
                labelText: "Fuel Level (%)",
                hintText: "Enter fuel level",
                keyboardType: TextInputType.number,
              ),
              _buildTextFormField(
                controller: _batteryLevelController,
                labelText: "Battery Level (%)",
                hintText: "Enter battery level",
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Update Vehicle"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }
}

