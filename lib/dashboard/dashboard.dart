import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nonograms/image_processing.dart';
import 'package:nonograms/router/router.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nonograms")),
      body: const Center(
        child: Text("Hi"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final picker = ImagePicker();
          final selected = await picker.pickImage(source: ImageSource.gallery);
          if (selected == null) {
            return;
          }
          final bytes = await selected.readAsBytes();
          final image = await loadImage(bytes);
          if (image == null) {
            return;
          }
          if (mounted) context.router.push(ImportSettingsRoute(image: image));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
