import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'project_card.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  List<Map<String, dynamic>> projects = [];
  String selectedFilter = "All";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/project/list-project'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        projects = List<Map<String, dynamic>>.from(jsonResponse['data']);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load projects');
    }
  }

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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
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
