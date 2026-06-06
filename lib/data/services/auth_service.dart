import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/app_user.dart';

/// 인증 관련 기능을 담당하는 서비스
/// Firebase Auth + Firestore를 함께 사용합니다.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// 현재 로그인된 사용자 (없으면 null)
  User? get currentUser => _auth.currentUser;

  /// 로그인 상태 변화 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// 이메일/비밀번호로 회원가입
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    // 1. Firebase Auth에 계정 생성
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;

    // 2. displayName 업데이트
    await user.updateDisplayName(displayName);

    // 3. Firestore에 사용자 정보 저장
    final appUser = AppUser(
      uid: user.uid,
      email: email,
      displayName: displayName,
      photoUrl: null,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(appUser.toFirestore());

    return appUser;
  }

  /// 이메일/비밀번호로 로그인
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;
    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      // 혹시 Firestore에 정보 없으면 기본값으로 생성
      final appUser = AppUser(
        uid: user.uid,
        email: email,
        displayName: user.displayName ?? email.split('@').first,
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(appUser.toFirestore());
      return appUser;
    }

    return AppUser.fromFirestore(doc);
  }

  /// 구글 로그인
  Future<AppUser> signInWithGoogle() async {
    // 1. 구글 계정 선택
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('구글 로그인이 취소되었습니다.');
    }

    // 2. 구글 인증 정보 받아오기
    final googleAuth = await googleUser.authentication;

    // 3. Firebase 자격증명 만들기
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 4. Firebase에 로그인
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user!;

    // 5. Firestore 사용자 정보 확인 + 없으면 생성
    final doc = await _firestore.collection('users').doc(user.uid).get();

    AppUser appUser;
    if (doc.exists) {
      appUser = AppUser.fromFirestore(doc);
    } else {
      appUser = AppUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '사용자',
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(appUser.toFirestore());
    }

    return appUser;
  }

  /// 로그아웃
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// 현재 사용자의 AppUser 정보 가져오기
  Future<AppUser?> getCurrentAppUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return AppUser.fromFirestore(doc);
  }
}
