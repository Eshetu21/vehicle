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
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    vehicle['name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${vehicle['status']}'),
                      Text('Location: ${vehicle['location']}'),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Fuel: ${vehicle['fuel_level']}%', style: TextStyle(color: Colors.green)),
                      Text('Battery: ${vehicle['battery_level']}%', style: TextStyle(color: Colors.blue)),
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
                ),
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
