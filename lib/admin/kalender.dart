import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final int idProject;

  const CalendarPage({required this.idProject});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<Map<String, dynamic>>> events;
  late List<Map<String, dynamic>> selectedEvents;
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  void initState() {
    super.initState();
    events = {};
    selectedDay = focusedDay;
    selectedEvents = [];
    fetchDetailProject(widget.idProject);
  }

  Future<void> fetchDetailProject(int idProject) async {
    final response = await http.get(Uri.parse(
        'http://127.0.0.1:8000/api/project/detail-project/$idProject'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final phases = data['data']['dataPhase'];

      setState(() {
        for (var phase in phases) {
          final startDate = DateTime.parse(phase['start_date']);
          final endDate = DateTime.parse(phase['end_date']);
          final eventDetails = {
            'phase': phase['phase'],
            'start_date': phase['start_date'],
            'end_date': phase['end_date'],
          };

          for (var date = startDate;
              date.isBefore(endDate.add(Duration(days: 1)));
              date = date.add(Duration(days: 1))) {
            if (events.containsKey(date)) {
              events[date]!.add(eventDetails);
            } else {
              events[date] = [eventDetails];
            }
          }
        }
        selectedEvents = _getEventsForDay(selectedDay!);
      });
    } else {
      throw Exception('Failed to load project details');
    }
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;
      selectedEvents = _getEventsForDay(selectedDay);

      if (selectedEvents.isNotEmpty) {
        _showEventDetailsModal(selectedEvents);
      }
    });
  }

  void _showEventDetailsModal(List<Map<String, dynamic>> events) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Event Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: events.map((event) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phase: ${event['phase']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Start Date: ${event['start_date']}'),
                    Text('End Date: ${event['end_date']}'),
                    Divider(),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Kalender Acara'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
            onFormatChanged: (format) {
              setState(() {
                calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              this.focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: selectedEvents.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Colors.blue),
                    title: Text(selectedEvents[index]['phase']),
                    subtitle: Text(
                        'Start: ${selectedEvents[index]['start_date']} End: ${selectedEvents[index]['end_date']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
