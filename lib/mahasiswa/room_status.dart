import 'package:flutter/material.dart';
import 'package:polispace/constants/colors.dart';
import 'package:polispace/mahasiswa/room_submission.dart';

class RoomStatus extends StatelessWidget {
  const RoomStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final data = {
      "id": 1,
      "name": "Gedung Utama-701",
      "status-grouping": [
        {
          "dateid": "Mon, 12 Nov, 2025",
          "status": [
            {
              "id": 1,
              "student_id": "312356445",
              "student_name": "Kurniyawan",
              "reason": "Presentasi untuk asesmen tengah semester",
              "from": "17:00",
              "to": "21:00",
            },
            {
              "id": 2,
              "student_id": "312356445",
              "student_name": "Bakwan",
              "reason": "Diskusi project based learning",
              "from": "21:00",
              "to": "22:00",
            },
          ],
        },
        {
          "dateid": "Tue, 13 Nov, 2025",
          "status": [
            {
              "id": 3,
              "student_id": "312356445",
              "student_name": "Kurniyawan",
              "reason": "Presentasi untuk asesmen tengah semester",
              "from": "17:00",
              "to": "21:00",
            },
            {
              "id": 2,
              "student_id": "312356445",
              "student_name": "Bakwan",
              "reason": "Diskusi project based learning",
              "from": "21:00",
              "to": "22:00",
            },
            {
              "id": 3,
              "student_id": "312356445",
              "student_name": "Kurniyawan",
              "reason": "Presentasi untuk asesmen tengah semester",
              "from": "17:00",
              "to": "21:00",
            },
          ],
        },
      ],
    };

    final statusGroups = data['status-grouping'] as List?;

    double containerHeight = MediaQuery.of(context).size.height * 0.27;
    double imageWidth =
        containerHeight + (MediaQuery.of(context).size.height * 0.05);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: BackButton(),
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: containerHeight,
            color: AppColors.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('assets/images/building.png', width: imageWidth),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'].toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed convallis nibh non congue fringilla.',
                  style: TextStyle(fontSize: 14, color: AppColors.textLight),
                ),
                SizedBox(height: 16),

                ...List.generate(statusGroups?.length ?? 0, (i) {
                  final group = statusGroups?[i];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(group['dateid'], style: TextStyle(fontSize: 14)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder:(context) => RoomSubmission()));
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.secondary,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 14,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      ...List.generate(group['status'].length, (j) {
                        final status = group['status'][j];
                        final currStatus = (i == 0 && j == 0)
                            ? "Sedang dipakai"
                            : "";
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: AppColors.primary,
                                      width: 3,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          status['student_name'],
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          currStatus,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 4),
                                    Text(
                                      "${status['from']} to ${status['to']}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      status['reason'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: 8),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      )
    );
  }
}
