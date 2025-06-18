import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<String, List<dynamic>> allSensorData = {};
  String selectedDevice = '';
  bool isLoading = false;
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    fetchAllSensorData();
  }

  Future<void> fetchAllSensorData() async {
    setState(() {
      isLoading = true;
      errorMsg = '';
    });

    try {
      final response =
          await http.get(Uri.parse('http://64.227.152.123:8000/data/all'));
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'];
        Map<String, List<dynamic>> sensors = {};

        if (data is Map) {
          if (data['esp32_sd_1_data'] is List) {
            sensors['ESP32 SD #1'] = data['esp32_sd_1_data'];
          }
          if (data['esp32_dht22_sensor_data'] is List) {
            sensors['ESP32 DHT22 Sensor'] = data['esp32_dht22_sensor_data'];
          }
        }

        setState(() {
          allSensorData = sensors;
          isLoading = false;
          errorMsg = '';
        });
      } else {
        setState(() {
          isLoading = false;
          errorMsg = 'Failed to load data: HTTP ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMsg = 'Error: $e';
      });
    }
  }

  void selectDevice(String deviceName) {
    setState(() {
      selectedDevice = deviceName;
    });
  }

  Widget buildDeviceButtons() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.green.shade50],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // First button - ESP32 SD #1
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                onPressed: allSensorData.containsKey('ESP32 SD #1')
                    ? () => selectDevice('ESP32 SD #1')
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedDevice == 'ESP32 SD #1'
                      ? Colors.blue.shade600
                      : Colors.white,
                  foregroundColor: selectedDevice == 'ESP32 SD #1'
                      ? Colors.white
                      : Colors.blue.shade600,
                  elevation: selectedDevice == 'ESP32 SD #1' ? 8 : 2,
                  shadowColor: Colors.blue.withOpacity(0.3),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: selectedDevice == 'ESP32 SD #1'
                          ? Colors.blue.shade600
                          : Colors.blue.shade200,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedDevice == 'ESP32 SD #1'
                            ? Colors.white.withOpacity(0.2)
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.memory,
                        size: 24,
                        color: selectedDevice == 'ESP32 SD #1'
                            ? Colors.white
                            : Colors.blue.shade600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ESP32 SD #1',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: selectedDevice == 'ESP32 SD #1'
                                  ? Colors.white
                                  : Colors.blue.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Storage Device',
                            style: TextStyle(
                              fontSize: 12,
                              color: selectedDevice == 'ESP32 SD #1'
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.blue.shade400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Second button - ESP32 DHT22
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: allSensorData.containsKey('ESP32 DHT22 Sensor')
                    ? () => selectDevice('ESP32 DHT22 Sensor')
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedDevice == 'ESP32 DHT22 Sensor'
                      ? Colors.green.shade600
                      : Colors.white,
                  foregroundColor: selectedDevice == 'ESP32 DHT22 Sensor'
                      ? Colors.white
                      : Colors.green.shade600,
                  elevation: selectedDevice == 'ESP32 DHT22 Sensor' ? 8 : 2,
                  shadowColor: Colors.green.withOpacity(0.3),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: selectedDevice == 'ESP32 DHT22 Sensor'
                          ? Colors.green.shade600
                          : Colors.green.shade200,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedDevice == 'ESP32 DHT22 Sensor'
                            ? Colors.white.withOpacity(0.2)
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.thermostat,
                        size: 24,
                        color: selectedDevice == 'ESP32 DHT22 Sensor'
                            ? Colors.white
                            : Colors.green.shade600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ESP32 DHT22',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: selectedDevice == 'ESP32 DHT22 Sensor'
                                  ? Colors.white
                                  : Colors.green.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Temperature & Humidity',
                            style: TextStyle(
                              fontSize: 12,
                              color: selectedDevice == 'ESP32 DHT22 Sensor'
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.green.shade400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectedDeviceData() {
    if (selectedDevice.isEmpty) {
      return const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.devices,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Select a slave device to view data',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final deviceData = allSensorData[selectedDevice] ?? [];

    if (deviceData.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'No data available for $selectedDevice',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      selectedDevice == 'ESP32 SD #1'
                          ? Icons.memory
                          : Icons.thermostat,
                      color: selectedDevice == 'ESP32 SD #1'
                          ? Colors.blue
                          : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$selectedDevice Data',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${deviceData.length} readings',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: deviceData.length,
              itemBuilder: (context, index) {
                final item = deviceData[index];
                final temperature = item['temperature']?.toString() ?? 'N/A';
                final humidity = item['humidity']?.toString() ?? 'N/A';
                final timestamp = item['timestamp']?.toString() ?? 'N/A';

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: selectedDevice == 'ESP32 SD #1'
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      child: Icon(
                        Icons.sensors,
                        color: selectedDevice == 'ESP32 SD #1'
                            ? Colors.blue
                            : Colors.green,
                      ),
                    ),
                    title: Text(
                      'Temp: $temperature°C, Humidity: $humidity%',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Timestamp: $timestamp',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    trailing: Text(
                      '#${index + 1}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ESP Slave Devices',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: fetchAllSensorData,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Data',
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // Device selection buttons
          buildDeviceButtons(),

          // Loading indicator
          if (isLoading)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading sensor data...'),
                  ],
                ),
              ),
            )

          // Error message
          else if (errorMsg.isNotEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errorMsg,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: fetchAllSensorData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )

          // No data available
          else if (allSensorData.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No sensor data available',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )

          // Selected device data
          else
            buildSelectedDeviceData(),
        ],
      ),
    );
  }
}
