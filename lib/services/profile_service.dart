import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<UserModel?> getProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return UserModel.fromMap(doc.data()!);
  }

  Future<void> updateProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(
      user.toMap(),
      SetOptions(merge: true),
    );
  }

  Future<String> uploadProfileImage({
    required String uid,
    required Uint8List imageBytes,
    ValueChanged<double>? onProgress,
  }) async {
    final uploadedAt = DateTime.now();
    final ref = _storage.ref().child('profile_images/$uid.jpg');
    final uploadTask = ref.putData(
      imageBytes,
      SettableMetadata(
        contentType: 'image/jpeg',
        cacheControl: 'public,max-age=3600',
      ),
    );

    final subscription = uploadTask.snapshotEvents.listen((snapshot) {
      final totalBytes = snapshot.totalBytes;
      if (totalBytes <= 0) return;
      onProgress?.call(snapshot.bytesTransferred / totalBytes);
    });

    try {
      await uploadTask;
      final downloadUrl = await ref.getDownloadURL();
      final photoUrl = _withCacheBust(downloadUrl, uploadedAt);

      await _firestore.collection('users').doc(uid).set(
        {
          'photoUrl': photoUrl,
          'updatedAt': uploadedAt.toIso8601String(),
        },
        SetOptions(merge: true),
      );

      onProgress?.call(1);
      return photoUrl;
    } finally {
      await subscription.cancel();
    }
  }

  Stream<UserModel?> profileStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      return UserModel.fromMap(snapshot.data()!);
    });
  }

  String _withCacheBust(String url, DateTime uploadedAt) {
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}v=${uploadedAt.millisecondsSinceEpoch}';
  }
}
