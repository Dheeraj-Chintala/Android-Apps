import 'package:dio/dio.dart';
import 'package:drivenote/models/drivefiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

final driveFilesProvider =
    StateNotifierProvider<DriveFilesNotifier, AsyncValue<List<DriveFile>>>(
  (ref) => DriveFilesNotifier()..loadFiles(),
);

class DriveFilesNotifier extends StateNotifier<AsyncValue<List<DriveFile>>> {
  DriveFilesNotifier() : super(const AsyncValue.loading());

  final _dio = Dio();
  final _storage = FlutterSecureStorage();

  Future<void> loadFiles() async {
    state = const AsyncValue.loading();
    try {
      String? token = await _storage.read(key: 'accesstoken');
      token ??= await getValidAccessToken();
      if (token == null) throw Exception("Missing token");

      String? folderId = await _storage.read(key: 'folderId');
      folderId ??= await getOrCreateDriveNotesFolder(_dio, token, _storage);

      final files = await fetchFilesInFolder(token, folderId);
      state = AsyncValue.data(files);
    } on DioException catch (e, st) {
      if (e.response?.statusCode == 401) {
        try {
          final newToken = await getValidAccessToken(forceRefresh: true);
          if (newToken != null) {
            final folderId = await getOrCreateDriveNotesFolder(_dio, newToken, _storage);
            final files = await fetchFilesInFolder(newToken, folderId);
            state = AsyncValue.data(files);
            return;
          }
        } catch (err, st2) {
          state = AsyncValue.error(err, st2);
          return;
        }
      }
      state = AsyncValue.error(e, st);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addFile(DriveFile file) {
    state = state.whenData((files) => [...files, file]);
  }

  void removeFile(String id) {
    state = state.whenData((files) => files.where((file) => file.id != id).toList());
  }

  void updateFileName(String id, String newName) {
    state = state.whenData((files) {
      return files.map((file) {
        return file.id == id ? file.copyWith(name: newName) : file;
      }).toList();
    });
  }

  Future<List<DriveFile>> fetchFilesInFolder(String token, String folderId) async {
    final response = await _dio.get(
      'https://www.googleapis.com/drive/v3/files',
      queryParameters: {
        'q': "'$folderId' in parents",
        'fields': 'files(id,name,mimeType)',
      },
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }),
    );

    final filesJson = response.data['files'] as List;
    return filesJson.map((json) => DriveFile.fromJson(json)).toList();
  }
}

Future<String?> getValidAccessToken({bool forceRefresh = false}) async {
  final googleSignIn = GoogleSignIn(
    scopes: ['https://www.googleapis.com/auth/drive.file', 'email'],
  );

  GoogleSignInAccount? account = googleSignIn.currentUser;
  if (account == null) {
    account = await googleSignIn.signInSilently();
    account ??= await googleSignIn.signIn();
  }

  final auth = await account?.authentication;
  final token = auth?.accessToken;

  if (token != null) {
    await FlutterSecureStorage().write(key: "accesstoken", value: token);
  }

  return token;
}


Future<String> getOrCreateDriveNotesFolder(
  Dio dio,
  String accessToken,
  FlutterSecureStorage storage,
) async {
  final response = await dio.get(
    'https://www.googleapis.com/drive/v3/files',
    queryParameters: {
      'q': "name = 'DriveNotes' and mimeType = 'application/vnd.google-apps.folder'",
      'fields': 'files(id,name)',
    },
    options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
  );

  final files = response.data['files'] as List;

  if (files.isNotEmpty) {
    final folderId = files.first['id'];
    await storage.write(key: 'folderId', value: folderId);
    return folderId;
  }

  final createRes = await dio.post(
    'https://www.googleapis.com/drive/v3/files',
    data: {
      'name': 'DriveNotes',
      'mimeType': 'application/vnd.google-apps.folder',
    },
    options: Options(
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    ),
  );

  final folderId = createRes.data['id'];
  await storage.write(key: 'folderId', value: folderId);
  return folderId;
}
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }
}