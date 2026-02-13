import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riyobox/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:riyobox/models/movie.dart';
import 'package:riyobox/core/constants.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _posterUrlController = TextEditingController();
  final _videoUrlController = TextEditingController();
  bool _isUploading = false;
  List<Movie> _movies = [];
  bool _isLoadingMovies = false;

  static const String _backendUrl = Constants.apiBaseUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    setState(() => _isLoadingMovies = true);
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    try {
      final response = await http.get(
        Uri.parse('$_backendUrl/admin/movies'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _movies = data.map((json) => Movie.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print('Error fetching movies: $e');
    } finally {
      setState(() => _isLoadingMovies = false);
    }
  }

  void _addMovie() async {
    if (_titleController.text.isEmpty || _videoUrlController.text.isEmpty) return;
    setState(() => _isUploading = true);
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/admin/movies'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'posterUrl': _posterUrlController.text,
          'videoUrl': _videoUrlController.text,
        }),
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Movie added successfully!')));
        _titleController.clear();
        _descriptionController.clear();
        _posterUrlController.clear();
        _videoUrlController.clear();
        _fetchMovies();
        _tabController.animateTo(1);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _deleteMovie(String? id) async {
    if (id == null) return;
    final token = Provider.of<AuthProvider>(context, listen: false).token;
     try {
      final response = await http.delete(
        Uri.parse('$_backendUrl/admin/movies/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Movie removed')));
        _fetchMovies();
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text('ADMIN PANEL', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF141414),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.deepPurpleAccent,
          tabs: const [
            Tab(text: 'UPLOAD'),
            Tab(text: 'MANAGE'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUploadTab(),
          _buildManageTab(),
        ],
      ),
    );
  }

  Widget _buildUploadTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('ADD NEW MOVIE', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildTextField(_titleController, 'Title'),
          const SizedBox(height: 16),
          _buildTextField(_descriptionController, 'Description', maxLines: 3),
          const SizedBox(height: 16),
          _buildTextField(_posterUrlController, 'Poster Image URL'),
          const SizedBox(height: 16),
          _buildTextField(_videoUrlController, 'Video URL (Direct link)'),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isUploading ? null : _addMovie,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isUploading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('UPLOAD MOVIE', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildManageTab() {
    if (_isLoadingMovies) return const Center(child: CircularProgressIndicator());
    if (_movies.isEmpty) return const Center(child: Text('No movies uploaded yet.', style: TextStyle(color: Colors.grey)));

    return ListView.builder(
      itemCount: _movies.length,
      itemBuilder: (context, index) {
        final movie = _movies[index];
        return ListTile(
          leading: Image.network(movie.posterPath, width: 50, height: 75, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.movie, color: Colors.grey)),
          title: Text(movie.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text(movie.releaseDate, style: const TextStyle(color: Colors.grey)),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => _deleteMovie(movie.backendId),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1C1C1C),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
      ),
    );
  }
}
