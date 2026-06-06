import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart' hide PaletteColor;
import 'package:uuid/uuid.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/color_classifier.dart';

/// 사진 처리 서비스
/// - 갤러리/카메라에서 사진 선택
/// - 사진에서 색상 추출
/// - Storage에 업로드
class PhotoService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  /// 갤러리에서 사진 선택
  Future<XFile?> pickFromGallery() async {
    return _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // 적당한 화질 (용량 절약)
      maxWidth: 2048,
    );
  }

  /// 카메라로 사진 촬영
  Future<XFile?> pickFromCamera() async {
    return _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 2048,
    );
  }

  /// 사진에서 주요 색상 추출 (최대 10개)
  Future<List<Color>> extractColors(XFile photo) async {
    final bytes = await photo.readAsBytes();
    final imageProvider = MemoryImage(bytes);

    final palette = await PaletteGenerator.fromImageProvider(
      imageProvider,
      maximumColorCount: 10,
    );

    return palette.colors.toList();
  }

  /// 사진에서 추출한 색상을 11개 카테고리로 분류하여 후보 반환
  Future<List<PaletteColor>> getColorCandidates(XFile photo) async {
    final colors = await extractColors(photo);
    final candidates = ColorClassifier.classifyMultiple(colors);
    return candidates.take(3).toList(); // 상위 3개만
  }

  /// Storage에 사진 업로드 (웹/모바일 모두 대응)
  Future<String> uploadPhoto(XFile photo) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다');
    }

    final fileName = '${_uuid.v4()}.jpg';
    final path = 'users/${user.uid}/photos/$fileName';
    final ref = _storage.ref().child(path);

    // 웹 호환을 위해 bytes로 업로드
    final bytes = await photo.readAsBytes();
    final task = await ref.putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    return await task.ref.getDownloadURL();
  }
}
