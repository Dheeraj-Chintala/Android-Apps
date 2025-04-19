import 'package:dio/dio.dart';
import 'package:drivenote/authenticate.dart';
import 'package:drivenote/models/drivefiles.dart';
import 'package:drivenote/screens/note.dart';
import 'package:drivenote/stateManagement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> listDriveFiles() async {
  final keystorage = FlutterSecureStorage();
  final accesstoken = await keystorage.read(key: "accesstoken");
  print(accesstoken);
  try {
    final response = await Dio().get(
      'https://www.googleapis.com/drive/v3/files',
      options: Options(
        headers: {
          'Authorization': 'Bearer $accesstoken',
          'Accept': 'application/json',
        },
      ),
    );
    print(response.data);
  } catch (e) {
    print(e.toString());
  }
}

class Home extends ConsumerWidget {
  const Home({super.key, this.file});
  final DriveFile? file;
  void openEditDialog(BuildContext context, DriveFile file) {
    showDialog(context: context, builder: (_) => Note(existingFile: file));
  }

  void openDeleteDialog(BuildContext context, DriveFile file, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Delete Note", style: GoogleFonts.ptSans()),
          content: Text("Are you sure you want to Delete Note?"),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                deleteNote(context, ref, file.id);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteNote(
    BuildContext context,
    WidgetRef ref,
    String file,
  ) async {
    final token = await const FlutterSecureStorage().read(key: 'accesstoken');
    final dio = Dio();

    try {
      await dio.delete(
        'https://www.googleapis.com/drive/v3/files/${file}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      ref.read(driveFilesProvider.notifier).removeFile(file);
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Note deleted')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete note')));
      print("Delete failed: $e");
    }
  }

  signoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to Logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Authenticate().signOut(context);
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driveFilesAsync = ref.watch(driveFilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Drive Notes", style: GoogleFonts.ptSans()),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              ref.read(themeNotifierProvider.notifier).toggleTheme();
            },
          ),
          IconButton(
            onPressed: () => signoutDialog(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: driveFilesAsync.when(
        data: (files) {
          if (files.isEmpty) return Center(child: Text("No files found."));
          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: const Color.fromARGB(98, 43, 255, 0),
                    child: ListTile(
                      title: Text(
                        file.name.toUpperCase(),
                        style: GoogleFonts.ptSans(fontSize: 30),
                      ),
                      subtitle: Text(file.mimeType),
                      onTap: () => openEditDialog(context, file),
                      onLongPress: () => openDeleteDialog(context, file, ref),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => const Note());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
