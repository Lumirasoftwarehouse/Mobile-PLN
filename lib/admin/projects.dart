import 'package:flutter/material.dart';
import 'project_card.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final List<Map<String, dynamic>> projects = [
    {
      "id": 1,
      "client": "ITS",
      "project": "Kuter",
      "status": "1",
      "dueDate": "2024-05-01",
      "created_at": "2024-06-17T15:37:58.000000Z",
      "updated_at": "2024-06-18T01:10:44.000000Z",
      "users": [
        {
          "id": 1,
          "name": "admin",
          "position": "test",
          "email": "admin@gmail.com",
          "email_verified_at": null,
          "level": "1",
          "status": "0",
          "created_at": "2024-06-17T15:37:58.000000Z",
          "updated_at": "2024-06-17T15:37:58.000000Z",
          "pivot": {"projectId": 1, "userId": 1}
        },
        {
          "id": 2,
          "name": "user",
          "position": "test",
          "email": "user@gmail.com",
          "email_verified_at": null,
          "level": "0",
          "status": "0",
          "created_at": "2024-06-17T15:37:58.000000Z",
          "updated_at": "2024-06-17T15:37:58.000000Z",
          "pivot": {"projectId": 1, "userId": 2}
        }
      ]
    },
    {
      "id": 2,
      "client": "Lumira",
      "project": "dua",
      "status": "0",
      "dueDate": "2024-06-01",
      "created_at": "2024-06-17T15:37:58.000000Z",
      "updated_at": "2024-06-18T01:16:06.000000Z",
      "users": [
        {
          "id": 2,
          "name": "user",
          "position": "test",
          "email": "user@gmail.com",
          "email_verified_at": null,
          "level": "0",
          "status": "0",
          "created_at": "2024-06-17T15:37:58.000000Z",
          "updated_at": "2024-06-17T15:37:58.000000Z",
          "pivot": {"projectId": 2, "userId": 2}
        }
      ]
    }
  ];

  String selectedFilter = "All";

  List<Map<String, dynamic>> get filteredProjects {
    if (selectedFilter == "All") {
      return projects;
    } else {
      return projects
          .where((project) => project["status"] == selectedFilter)
          .toList();
    }
  }

  void setFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blue[50],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilterButton(
                    text: "All",
                    isSelected: selectedFilter == "All",
                    onPressed: () => setFilter("All"),
                  ),
                  FilterButton(
                    text: "In Progress",
                    isSelected: selectedFilter == "0",
                    onPressed: () => setFilter("0"),
                  ),
                  FilterButton(
                    text: "Completed",
                    isSelected: selectedFilter == "1",
                    onPressed: () => setFilter("1"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProjects.length,
                itemBuilder: (context, index) {
                  final project = filteredProjects[index];
                  return ProjectCard(project: project);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow,
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Colors.blue : Colors.blue[100],
        onPrimary: isSelected ? Colors.white : Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
