import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mini_shop_app/features/auth/models/user_profile.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  String get baseUrl => dotenv.env['FIREBASE_DB_URL']!;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithGoogle({required String role}) async {
    await _googleSignIn.initialize();
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

    if (googleUser == null) return null;
    final clientAuth = await googleUser.authorizationClient
        .authorizationForScopes(['email', 'profile']);
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: clientAuth?.accessToken,
      idToken: googleUser.authentication.idToken,
    );

    final res = await _auth.signInWithCredential(credential);
    await getNewUser(res, role);
    return res;
  }

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String role,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await getNewUser(userCredential, role);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<UserProfile?> fetchUserProfile(String uid, String token) async {
    final url = Uri.https(baseUrl, 'users/$uid.json', {'auth': token});

    final response = await http.get(url);

    if (response.statusCode >= 400 || response.body == 'null') {
      return null;
    }
    final data = UserProfile.fromJson(
      id: uid,
      source: json.decode(response.body),
    );
    return data;
  }

  Future<void> getNewUser(UserCredential userCredential, String role) async {
    final user = userCredential.user;
    if (user == null) throw Exception('Failed to create auth account');
    final token = await user.getIdToken();
    final url = Uri.https(baseUrl, 'users/${user.uid}.json', {'auth': token});

    final response = await http.put(
      url,
      body: json.encode({
        'email': user.email,
        'role': role,
        // ISO 8601 is the industry standard for saving timestamps in databases
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );
    if (response.statusCode >= 400) {
      // If the database write fails, ideally the Auth user should be deleted
      // here to prevent "orphan" accounts, but we'll throw an error for now.
      throw Exception('Could not create user profile in database.');
    }
  }
}
