import 'package:car/edit_vehicle.dart';
import 'package:flutter/material.dart';
import 'package:car/add_vehicle.dart';
import 'services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  final SupabaseService _service = SupabaseService();
  late Future<List<Map<String, dynamic>>> _vehiclesFuture;

  @override
  void initState() {
    super.initState();
    _vehiclesFuture = _service.fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vehicle Monitoring')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _vehiclesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data!.isEmpty) {
            return Center(child: const Text("No vehicles found"));
          }
          final vehicles = snapshot.data!;
          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return ListTile(
                title: Text(vehicle['name']),
                subtitle: Text(
                    'Status: ${vehicle['status']}, Location: ${vehicle['location']}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Fuel: ${vehicle['fuel_level']}%'),
                    Text('Battery: ${vehicle['battery_level']}%'),
                  ],
                ),
                onTap: () async {
                  bool? shouldReload = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditVehicle(vehicle: vehicle)),
                  );

                  if (shouldReload == true) {
                    setState(() {
                      _vehiclesFuture = _service.fetchVehicles();
                    });
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? shouldReload = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVehicleScreen()),
          );

          if (shouldReload == true) {
            setState(() {
              _vehiclesFuture = _service.fetchVehicles();
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


