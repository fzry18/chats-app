import 'package:chatapp/app/data/models/users_model.dart';
import 'package:chatapp/app/data/models/chats_model.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:chatapp/app/utils/snackbar_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  var isSkipIntroduction = false.obs;
  var isAuthenticated = false.obs;

  final box = GetStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  var userModel = UsersModel().obs;

  late FirebaseFirestore firestore;

  @override
  void onInit() {
    super.onInit();
    firestore = FirebaseFirestore.instance;
    initGoogleSignIn();
  }

  Future<void> firstInitialized() async {
    try {
      // Check skip intro terlebih dahulu
      final skip = await skipIntro();
      isSkipIntroduction.value = skip;

      // Jika sudah pernah login, coba auto login
      if (skip) {
        final auth = await autoLogin();
        isAuthenticated.value = auth;
      }
    } catch (e) {
      print('Error in firstInitialized: $e');
    }
  }

  Future<bool> skipIntro() async {
    final skipIntro = box.read('skipIntro') ?? false;
    return skipIntro;
  }

  Future<bool> autoLogin() async {
    try {
      // Refresh user untuk mendapatkan metadata terbaru
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Update lastSignInTime dengan waktu saat ini
        final now = DateTime.now().toIso8601String();
        await firestore.collection('users').doc(user.email).update({
          'lastSignInTime': now,
        });

        // Ambil data user yang sudah terupdate
        final userData =
            await firestore.collection('users').doc(user.email).get();

        if (userData.exists && userData.data() != null) {
          // Gunakan fromJson untuk convert data
          userModel.value = UsersModel.fromJson(userData.data()!);
          return true;
        }
      }
      return false;
    } catch (err) {
      print('Error in autoLogin: $err');
      return false;
    }
  }

  void initGoogleSignIn() {
    _googleSignIn.initialize(
      serverClientId:
          '331427733305-c4avnuh8ba4p4q8rosror5c2s9j4iu61.apps.googleusercontent.com',
    );
  }

  Future<void> loginWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.authenticate();

      if (googleUser == null) {
        return;
      }

      // Get auth headers
      final Map<String, String>? headers =
          await googleUser.authorizationClient.authorizationHeaders(['email']);

      if (headers == null) {
        print('Failed to get authorization headers');
        return;
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: headers['Authorization']?.replaceAll('Bearer ', ''),
        idToken: null,
      );

      // Sign in to Firebase with the Google Auth credentials
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        print('=== Google Sign In Success ===');
        print(googleUser);
        print(user);

        // Set authenticated state
        isAuthenticated.value = true;

        // Save skip intro state
        box.write('skipIntro', true);
        isSkipIntroduction.value = true;

        // Save user data to Firestore
        CollectionReference users = firestore.collection('users');

        final checkUser = await users.doc(user.email).get();

        // Logic dibalik: checkUser.data() == null artinya user baru
        if (checkUser.data() == null) {
          // Buat model user baru
          final newUser = UsersModel(
            uid: user.uid,
            email: user.email,
            name: user.displayName,
            photoUrl: user.photoURL ?? "noimage",
            status: '',
            creationTime: user.metadata.creationTime?.toIso8601String(),
            lastSignInTime: user.metadata.lastSignInTime?.toIso8601String(),
            updatedTime: DateTime.now().toIso8601String(),
            keyName: user.displayName!.substring(0, 1).toUpperCase(),
            chats: [],
          );

          // Simpan ke Firestore menggunakan toJson
          await users.doc(user.email).set(newUser.toJson());
          userModel.value = newUser;
        } else {
          // User sudah ada, update lastSignInTime
          await users.doc(user.email).update({
            'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
          });

          // Ambil data terbaru dan convert ke model
          final currentUser = await users.doc(user.email).get();
          if (currentUser.exists && currentUser.data() != null) {
            userModel.value = UsersModel.fromJson(
                currentUser.data()! as Map<String, dynamic>);
          }
        }

        // Navigate to home
        Get.offAllNamed(Routes.HOME);
      } else {
        print('=== Google Sign In Failed ===');
      }
    } catch (error) {
      print('=== Google Sign In Error ===');
      print(error);
      SnackbarUtils.showError(
        title: 'Error',
        message: 'Gagal login dengan Google',
      );
    }
  }

  Future<void> logout() async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();
      // Sign out from Google
      await _googleSignIn.signOut();

      print('=== Sign Out Success ===');
      print('User logged out successfully');
      isAuthenticated.value = false;
      Get.offAllNamed(Routes.LOGIN);
    } catch (error) {
      print('Error saat logout: $error');
    }
  }

  // Function untuk mengupdate status user
  Future<void> updateStatus(String status) async {
    try {
      // Mengambil waktu saat ini untuk update time
      String date = DateTime.now().toIso8601String();

      // Reference ke collection users di Firestore
      CollectionReference users = firestore.collection('users');

      // Update status di Firestore
      await users.doc(userModel.value.email).update({
        'status': status,
        'updatedTime': date,
      });

      // Ambil data terbaru setelah update
      final currentUser = await users.doc(userModel.value.email).get();
      final userData = currentUser.data() as Map<String, dynamic>?;

      if (userData != null) {
        // Update userModel dengan data terbaru
        userModel.update((model) {
          model?.status = userData['status'];
          model?.updatedTime = userData['updatedTime'];
        });

        userModel.refresh(); // Refresh observable

        // Kembali ke halaman sebelumnya
        Get.back();

        // Tampilkan pesan sukses
        SnackbarUtils.showSuccess(
          title: 'Berhasil',
          message: 'Status berhasil diupdate',
        );
      }
    } catch (error) {
      print('Error in updateStatus: $error');
      // Tampilkan pesan error
      SnackbarUtils.showError(
        title: 'Error',
        message: 'Gagal mengupdate status',
      );
    }
  }

  // Function untuk mengubah profile user (nama dan status)
  Future<void> changeProfile(String name, String status) async {
    try {
      // Mengambil waktu saat ini untuk update time
      String date = DateTime.now().toIso8601String();

      // Reference ke collection users di Firestore
      CollectionReference users = firestore.collection('users');

      // Update data di Firestore
      await users.doc(userModel.value.email).update({
        'name': name,
        'keyName': name.substring(0, 1).toUpperCase(),
        'status': status,
        'updatedTime': date,
        'lastSignInTime': userModel
            .value.lastSignInTime, // Pertahankan lastSignInTime yang ada
      });

      // Ambil data terbaru setelah update
      final currentUser = await users.doc(userModel.value.email).get();
      final userData = currentUser.data() as Map<String, dynamic>?;

      if (userData != null) {
        // Update userModel dengan data terbaru
        userModel.update((model) {
          model?.name = userData['name'];
          model?.keyName = userData['keyName'];
          model?.status = userData['status'];
          model?.updatedTime = userData['updatedTime'];
          model?.lastSignInTime = userData['lastSignInTime'];
        });

        userModel.refresh(); // Refresh observable

        Get.back(); // Kembali ke halaman sebelumnya

        // Tampilkan pesan sukses
        SnackbarUtils.showSuccess(
          title: 'Berhasil',
          message: 'Profile berhasil diupdate',
        );
      }
    } catch (error) {
      print('Error in changeProfile: $error');
      // Tampilkan pesan error
      SnackbarUtils.showError(
        title: 'Error',
        message: 'Gagal mengupdate profile',
      );
    }
  }

  Future<void> newChatConnection(String friendEmail) async {
    try {
      // 1. Cek di collection chats apakah sudah ada koneksi antara kedua user
      CollectionReference chats = firestore.collection('chats');

      // Query untuk mencari chat yang melibatkan kedua user
      final chatQuery = await chats
          .where('connections', arrayContains: userModel.value.email)
          .get();

      // Cek apakah ada dokumen yang juga mengandung email friend
      final existingChat = chatQuery.docs
          .where((doc) => (doc.data() as Map<String, dynamic>)['connections']
              .contains(friendEmail))
          .toList();

      // Jika sudah ada chat
      if (existingChat.isNotEmpty) {
        final existingChatId = existingChat[0].id;
        Get.toNamed(
          Routes.CHAT_ROOM,
          arguments: {
            "chat_id": existingChatId,
            "friendEmail": friendEmail,
          },
        );
        return;
      }

      // 2. Jika belum ada, cek juga di userModel (double check)
      if (userModel.value.chats != null) {
        final existingChat = userModel.value.chats!
            .where((chat) => chat.connection == friendEmail)
            .toList();

        if (existingChat.isNotEmpty) {
          Get.toNamed(
            Routes.CHAT_ROOM,
            arguments: {
              "chat_id": existingChat[0].chatId,
              "friendEmail": friendEmail,
            },
          );
          return;
        }
      }

      String date = DateTime.now().toIso8601String();

      // Buat data chat sesuai dengan ChatsModel
      final newChat = ChatsModel(
        connections: [userModel.value.email!, friendEmail],
        chat: [],
      ).toJson();

      // Update field names sesuai model json
      newChat['last_Time'] = date; // Set current time
      newChat['total_unread'] = 0; // Add total_unread field
      newChat['lastMessage'] = null; // Add lastMessage field

      // Simpan ke Firestore
      final newChatDoc = await chats.add(newChat);
      final chatId = newChatDoc.id;
      print("=== Chat Creation Info ===");
      print("New Chat Document ID: ${chatId}");
      print("Chat Data: ${newChat}");

      // Update user yang memulai chat sesuai dengan model users_model.json
      final myNewChat = {
        'connection': friendEmail,
        'chat_id': chatId,
        'lastTime': date,
        'total_unread': 0
      };

      // Update user yang diajak chat
      final friendNewChat = {
        'connection': userModel.value.email,
        'chat_id': chatId,
        'lastTime': date,
        'total_unread': 0
      };

      // Update kedua user secara bersamaan
      CollectionReference users = firestore.collection('users');
      await Future.wait([
        users.doc(userModel.value.email).update({
          'chats': FieldValue.arrayUnion([myNewChat])
        }),
        users.doc(friendEmail).update({
          'chats': FieldValue.arrayUnion([friendNewChat])
        })
      ]);

      // Refresh data user model
      final currentUser = await users.doc(userModel.value.email).get();
      if (currentUser.exists && currentUser.data() != null) {
        userModel.value =
            UsersModel.fromJson(currentUser.data()! as Map<String, dynamic>);
      }

      print("=== Navigation Info ===");
      print("Navigating to chat room with ID: ${chatId}");
      // Navigate ke chat room dengan chat ID dan email teman
      Get.toNamed(
        Routes.CHAT_ROOM,
        arguments: {
          "chat_id": chatId,
          "friendEmail": friendEmail,
        },
      );
    } catch (e) {
      print('Error creating new chat: $e');
      SnackbarUtils.showError(
        title: 'Error',
        message: 'Gagal membuat chat baru',
      );
    }
  }
}
