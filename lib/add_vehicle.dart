import 'package:flutter/material.dart';
import 'services.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _service = SupabaseService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _fuelLevelController = TextEditingController();
  final TextEditingController _batteryLevelController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final status = _statusController.text;
      final location = _locationController.text;
      final fuelLevel = double.tryParse(_fuelLevelController.text) ?? 0.0;
      final batteryLevel = double.tryParse(_batteryLevelController.text) ?? 0.0;

      final vehicleData = {
        'name': name,
        'status': status,
        'location': location,
        'fuel_level': fuelLevel,
        'battery_level': batteryLevel,
      };

      await _service.addOrUpdateVehicle(null, vehicleData);

      Navigator.pop(context, true); // Notify homepage to reload.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Vehicle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(
                controller: _nameController,
                labelText: 'Vehicle Name',
                hintText: 'Enter vehicle name',
              ),
              _buildTextFormField(
                controller: _statusController,
                labelText: 'Status',
                hintText: 'Enter vehicle status',
              ),
              _buildTextFormField(
                controller: _locationController,
                labelText: 'Location',
                hintText: 'Enter location',
              ),
              _buildTextFormField(
                controller: _fuelLevelController,
                labelText: 'Fuel Level (%)',
                hintText: 'Enter fuel level',
                keyboardType: TextInputType.number,
              ),
              _buildTextFormField(
                controller: _batteryLevelController,
                labelText: 'Battery Level (%)',
                hintText: 'Enter battery level',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Vehicle'),
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
