import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:polispace/all_user/add_building.dart';
import 'package:polispace/all_user/add_room.dart';
import 'package:polispace/all_user/detail_room.dart';
import 'package:polispace/all_user/home.dart';
import 'package:polispace/constants/colors.dart';
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
      appBar: AppBar(
        title: const Text(
          "Daftar Ruangan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,

        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: _accessID == 4
          ? SpeedDial(
              icon: Icons.add,
              foregroundColor: Colors.white,
              activeIcon: Icons.close,
              activeForegroundColor: Colors.white,
              backgroundColor: const Color(0xFF2D71F8),

              children: [
                SpeedDialChild(
                  shape: const CircleBorder(),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF2D71F8),
                  child: const Icon(Icons.door_front_door),
                  labelWidget: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: AppColors.primary, width: 3),
                      ),
                      color: AppColors.soft.withOpacity(0.5),
                      // borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text("Tambah Ruangan"),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddRoomPage(),
                      ),
                    );
                  },
                ),
                SpeedDialChild(
                  shape: const CircleBorder(),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF2D71F8),
                  child: const Icon(Icons.business),
                  labelWidget: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: AppColors.primary, width: 3),
                      ),
                      color: AppColors.soft.withOpacity(0.5),
                      // borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text("Tambah Gedung"),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddBuildingPage(),
                      ),
                    );
                  },
                ),
              ],
            )
          : null,
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
                        // if (_accessID == 4)
                        //   Container(
                        //     padding: const EdgeInsets.all(4),
                        //     decoration: BoxDecoration(
                        //       color: AppColors.soft.withOpacity(0.5),
                        //       borderRadius: BorderRadius.circular(50),
                        //     ),
                        //     child: ElevatedButton(
                        //       onPressed: () async {
                        //         final result = await Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => const AddRoomPage(),
                        //           ),
                        //         );

                        //         if (result == true) {
                        //           await _loadBuildingsAndRooms();
                        //         }
                        //       },

                        //       style: ElevatedButton.styleFrom(
                        //         padding: const EdgeInsets.symmetric(
                        //           horizontal: 18,
                        //           vertical: 18,
                        //         ),

                        //         backgroundColor: const Color(0xFF2D71F8),
                        //       ),

                        //       child: const Text(
                        //         'Tambah Ruangan',
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //     ),
                        //   ),

                        // const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    double containerHeight = MediaQuery.of(context).size.height * 0.27;
    double imageWidth =
        containerHeight + (MediaQuery.of(context).size.height * 0.05);
    return Container(
      width: double.infinity,
      height: containerHeight,
      color: AppColors.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset('assets/images/building.png', width: imageWidth),
        ],
      ),
    );
  }

  Widget _buildCategoryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.soft.withOpacity(0.5),
                borderRadius: BorderRadius.circular(50),
              ),
              clipBehavior: Clip.hardEdge,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: buildings.map((b) {
                    final title = b['BuildingName'];
                    return Padding(
                      padding: EdgeInsets.zero,
                      child: _buildCategoryButton(
                        title,
                        selectedCategory == title,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // if (_accessID == 4)
          //   Container(
          //     padding: const EdgeInsets.all(4),
          //     decoration: const BoxDecoration(
          //       color: Color(0xFFE0E7FF),
          //       shape: BoxShape.circle,
          //     ),
          //     child: ElevatedButton(
          //       onPressed: () async {
          //         final result = await Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => const AddBuildingPage(),
          //           ),
          //         );
          //         if (result == true) {
          //           await _loadBuildingsAndRooms();
          //         }
          //       },
          //       style: ElevatedButton.styleFrom(
          //         shape: const CircleBorder(),
          //         backgroundColor: const Color(0xFF2D71F8),
          //         padding: const EdgeInsets.all(20),
          //         elevation: 0,
          //       ),
          //       child: const Icon(Icons.add, color: Colors.white),
          //     ),
          //   ),
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
            : AppColors.soft.withOpacity(0),
        foregroundColor: isActive ? Colors.white : AppColors.text,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Icon(Icons.apartment, size: 18),
          // const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
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
      child:
          // Container(
          //   margin: const EdgeInsets.only(bottom: 12),
          //   padding: const EdgeInsets.all(14),
          //   decoration: BoxDecoration(
          //     color: AppColors.soft.withOpacity(0.5),
          //     borderRadius: BorderRadius.circular(50),
          //   ),
          //   child: Text(
          //     "$roomId - $roomName",
          //     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0x80c0d4fd),
                border: Border(
                  left: BorderSide(color: AppColors.primary, width: 3),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(roomId, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(
                    roomName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
