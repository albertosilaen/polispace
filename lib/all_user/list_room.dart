import 'package:flutter/material.dart';
import 'package:polispace/all_user/detail_room.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListRoomPage extends StatefulWidget {
  const ListRoomPage({super.key});

  @override
  State<ListRoomPage> createState() => _ListRoomPageState();
}

class _ListRoomPageState extends State<ListRoomPage> {
  final supabase = Supabase.instance.client;

  int? _accessID;
  String? selectedCategory;

  List<Map<String, dynamic>> buildings = [];
  Map<String, List<Map<String, String>>> roomsByCategory = {};

  @override
  void initState() {
    super.initState();
    _loadAccessID();
    _loadBuildingsAndRooms();
  }

  Future<void> _loadAccessID() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _accessID = prefs.getInt('AccessID');
    });
  }

  Future<void> _loadBuildingsAndRooms() async {
    try {
      final buildingData = await supabase.from('tblBuilding').select();
      final roomData = await supabase.from('tblRoom').select();

      if (!mounted) return;

      Map<String, List<Map<String, String>>> tempMap = {};
      for (var building in buildingData) {
        final buildingID = building['BuildingID'];
        final buildingName = building['BuildingName'];

        final rooms = roomData
            .where((r) => r['BuildingID'] == buildingID)
            .map<Map<String, String>>(
              (r) => {
                'RoomID': r['RoomID'] ?? '',
                'RoomName': r['RoomName'] ?? '',
              },
            )
            .toList();

        tempMap[buildingName] = rooms;
      }

      setState(() {
        buildings = List<Map<String, dynamic>>.from(buildingData);
        roomsByCategory = tempMap;
        if (buildings.isNotEmpty) {
          selectedCategory = buildings.first['BuildingName'];
        }
      });
    } catch (e) {
      debugPrint('Error load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> currentRooms =
        roomsByCategory[selectedCategory] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: buildings.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildCategoryRow(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        for (final room in currentRooms) _buildRoomItem(room),
                        if (_accessID == 4)
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D71F8),
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E5E5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "Gedung",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      buildings.length.toString(),
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 2, height: 70, color: Colors.black26),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "Ruang",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      roomsByCategory.values
                          .fold<int>(0, (sum, list) => sum + list.length)
                          .toString(),
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Atur jadwalmu, manfaatkan ruangmu",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: buildings.map((b) {
                  final title = b['BuildingName'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: _buildCategoryButton(
                      title,
                      selectedCategory == title,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          if (_accessID == 4)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: const Color(0xFF2D71F8),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String title, bool isActive) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = title;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive
            ? const Color(0xFF2D71F8)
            : Colors.grey.shade400,
        foregroundColor: Colors.white,
      ),
      child: Text(title),
    );
  }

  Widget _buildRoomItem(Map<String, String> room) {
    final roomId = room['RoomID'] as String;
    final roomName = room['RoomName'] as String;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RoomDetail(roomId: roomId, roomName: roomName),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "$roomId - $roomName",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
