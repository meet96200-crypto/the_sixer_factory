import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/news_model.dart';
import '../../providers/news_provider.dart';

class EditNewsScreen extends StatefulWidget {
  final NewsModel news;

  const EditNewsScreen({
    super.key,
    required this.news,
  });

  @override
  State<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageController;
  late final TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();

    _titleController =
        TextEditingController(text: widget.news.title);

    _descriptionController =
        TextEditingController(text: widget.news.description);

    _imageController =
        TextEditingController(text: widget.news.imageUrl);

    _categoryController =
        TextEditingController(text: widget.news.category);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _updateNews() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedNews = widget.news.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: _imageController.text.trim(),
      category: _categoryController.text.trim(),
    );

    await context.read<NewsProvider>().updateNews(updatedNews);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("News Updated Successfully"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xff111827),
        title: const Text("Edit News"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "News Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Enter title"
                    : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Enter description"
                    : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: "Image URL",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Enter image url"
                    : null,
              ),

              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _imageController.text,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 180,
                    color: Colors.grey.shade800,
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Enter category"
                    : null,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton.icon(
                  onPressed: _updateNews,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Update News",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}