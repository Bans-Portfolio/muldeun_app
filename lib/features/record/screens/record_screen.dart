import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/color_classifier.dart';
import '../../../data/models/record_entry.dart';
import '../providers/record_provider.dart';

/// 기록 작성 화면 — 사진 미리보기, 색상 추출, 저장
class RecordScreen extends ConsumerStatefulWidget {
  final XFile photo;

  const RecordScreen({super.key, required this.photo});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  Uint8List? _photoBytes;
  List<PaletteColor> _colorCandidates = [];
  PaletteColor? _selectedColor;
  final TextEditingController _noteController = TextEditingController();
  bool _isExtracting = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadPhotoAndExtractColors();
  }

  Future<void> _loadPhotoAndExtractColors() async {
    try {
      // 사진 바이트 읽기 (미리보기용)
      final bytes = await widget.photo.readAsBytes();

      // 색상 추출
      final candidates =
          await ref.read(photoServiceProvider).getColorCandidates(widget.photo);

      if (mounted) {
        setState(() {
          _photoBytes = bytes;
          _colorCandidates = candidates;
          _selectedColor = candidates.isNotEmpty ? candidates.first : null;
          _isExtracting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isExtracting = false);
        _showError('색상을 분석하는 중 오류가 발생했어요');
      }
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedColor == null) {
      _showError('대표 색상을 선택해주세요');
      return;
    }

    setState(() => _isSaving = true);

    try {
      // 1. 사진을 Storage에 업로드
      final photoUrl = await ref
          .read(photoServiceProvider)
          .uploadPhoto(widget.photo);

      // 2. 추출된 색상들 hex로 변환 (참고 데이터로 저장)
      final extractedColors = await ref
          .read(photoServiceProvider)
          .extractColors(widget.photo);
      final hexColors =
          extractedColors.map(ColorClassifier.toHex).toList();

      // 3. Firestore에 기록 추가
      final user = FirebaseAuth.instance.currentUser!;
      final record = RecordEntry(
        id: '', // Firestore가 자동 생성
        userId: user.uid,
        date: DateTime.now(),
        photoUrl: photoUrl,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        selectedColor: _selectedColor!,
        extractedColors: hexColors,
        createdAt: DateTime.now(),
      );

      await ref.read(recordRepositoryProvider).add(record);

      // 4. 완료 후 홈으로
      if (mounted) {
        _showSuccess();
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        _showError('저장 중 오류가 발생했어요: ${e.toString().split(']').last.trim()}');
        setState(() => _isSaving = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _showSuccess() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('기록이 저장되었어요! 🎉'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy년 M월 d일').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: Text(dateStr)),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPhotoPreview(),
                      const SizedBox(height: 24),
                      _buildColorSection(),
                      const SizedBox(height: 24),
                      Text('메모', style: AppTextStyles.bodyLarge),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _noteController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: '오늘의 산책을 짧게 남겨보세요',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed:
                      (_selectedColor != null && !_isSaving) ? _submit : null,
                  child: Text(_isSaving ? '저장 중...' : '기록 완료'),
                ),
              ),
            ],
          ),
          if (_isSaving)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              alignment: Alignment.center,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    '기록을 저장하고 있어요...',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhotoPreview() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: _photoBytes != null
          ? Image.memory(_photoBytes!, fit: BoxFit.cover, width: double.infinity)
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('대표 색상', style: AppTextStyles.bodyLarge),
            const SizedBox(width: 8),
            if (_isExtracting)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _isExtracting ? '색상을 분석하고 있어요...' : '오늘의 산책을 어떤 색으로 기록할까요?',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 12),
        if (!_isExtracting && _colorCandidates.isNotEmpty)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _colorCandidates
                .map((color) => _ColorChoiceChip(
                      color: color,
                      isSelected: _selectedColor == color,
                      onTap: () => setState(() => _selectedColor = color),
                    ))
                .toList(),
          ),
        if (!_isExtracting) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _showAllColorsBottomSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '다른 색 선택',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showAllColorsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('색상 선택', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: PaletteColor.values
                  .map((color) => _ColorChoiceChip(
                        color: color,
                        isSelected: _selectedColor == color,
                        onTap: () {
                          setState(() => _selectedColor = color);
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ColorChoiceChip extends StatelessWidget {
  final PaletteColor color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorChoiceChip({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.color : Colors.white,
          border: Border.all(
            color: color.color,
            width: isSelected ? 0 : 2,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : color.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              color.label,
              style: TextStyle(
                color: isSelected
                    ? (color == PaletteColor.white
                        ? AppColors.textPrimary
                        : Colors.white)
                    : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
