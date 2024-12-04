import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// auth function

  // Fungsi untuk meng-upload gambar profil ke Firebase Storage
  Future<String?> uploadProfileImage(File? profileImage, String email) async {
    if (profileImage == null) {
      return null;
    }

    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_images/${email}.jpg');

      await storageRef.putFile(profileImage);
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  // Fungsi untuk melakukan registrasi pengguna
  Future<UserCredential?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      return null;
    }
  }

  // Fungsi untuk menyimpan data pengguna ke Firestore
  Future<void> saveUserData(
    String userId,
    String email,
    String fullName,
    String username,
    DateTime? dateOfBirth,
    String? profileImageUrl,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('user_data').doc(userId).set({
        'user_email': email,
        'full_name': fullName,
        'username': username,
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'profile_image': profileImageUrl,
      });
    } catch (e) {
      throw Exception('Error saving user data');
    }
  }

  /// cart function

  // Menyimpan item ke dalam sub-koleksi cart Firestore
  Future<void> insertCartItem(Map<String, dynamic> cartItem) async {
    try {
      // Mendapatkan userId dari Firebase Authentication
      String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception("User belum login");
      }

      String cartId = _firestore
          .collection('user_data')
          .doc(userId)
          .collection('purchase_history_item')
          .doc()
          .id;

      cartItem['id'] = cartId;
      await _firestore
          .collection('user_data')
          .doc(userId)
          .collection('cart_item')
          .doc(cartId)
          .set(cartItem);
      print("Item berhasil ditambahkan ke Firestore");
    } catch (e) {
      print("Error menambahkan item ke Firestore: $e");
    }
  }

  // Mendapatkan data cart dari Firestore
  Future<List<Map<String, dynamic>>> getCartItems() async {
    try {
      String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception("User belum login");
      }

      // Mendapatkan data cart milik user
      QuerySnapshot snapshot = await _firestore
          .collection('user_data')
          .doc(userId)
          .collection('cart_item')
          .get();

      List<Map<String, dynamic>> cartItems = [];
      for (var doc in snapshot.docs) {
        cartItems.add(doc.data() as Map<String, dynamic>);
      }
      return cartItems;
    } catch (e) {
      print("Error mendapatkan item cart: $e");
      return [];
    }
  }

  Future<void> deleteCartItem(String cartId) async {
    try {
      String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception("User belum login");
      }
      await _firestore
          .collection('user_data')
          .doc(userId)
          .collection('cart_item')
          .doc(cartId)
          .delete();
    } catch (e) {
      print("Error menghapus item dari cart: $e");
    }
  }

  /// purhcase history function
  Future<void> insertPurchaseHistory(Map<String, dynamic> purchaseItem) async {
    try {
      String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception("User belum login");
      }
      String purchaseId = _firestore
          .collection('user_data')
          .doc(userId)
          .collection('purchase_history_item')
          .doc()
          .id;

      purchaseItem['id'] = purchaseId;

      await _firestore
          .collection('user_data')
          .doc(userId)
          .collection('purchase_history_item')
          .doc(purchaseId)
          .set(purchaseItem);
    } catch (e) {
      print("Error menambahkan item ke Firestore: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getPurchaseHistory() async {
    try {
      String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception("User belum login");
      } else {
        QuerySnapshot snapshot = await _firestore
            .collection('user_data')
            .doc(userId)
            .collection('purchase_history_item')
            .get();

        List<Map<String, dynamic>> purchaseItems = [];
        for (var doc in snapshot.docs) {
          purchaseItems.add(doc.data() as Map<String, dynamic>);
        }
        return purchaseItems;
      }
    } catch (e) {
      print("Error mendapatkan history purchase: $e");
      return [];
    }
  }

  /// chat function

  Future<void> saveChatHistory(
      String userId, String productName, String message, bool isUser) async {
    try {
      // Menyimpan chat history ke Firestore
      DocumentReference chatRef = await _firestore
          .collection('user_data')
          .doc(userId)
          .collection('chat_history')
          .add({
        'product_name': productName,
        'message': message,
        'is_user': isUser,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Pesan berhasil disimpan dengan ID: ${chatRef.id}");
    } catch (e) {
      print("Error menyimpan pesan: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getChatHistory(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('user_data')
          .doc(userId)
          .collection('chat_history')
          .orderBy('timestamp', descending: true)
          .limit(20) // Batasan untuk mengambil 20 pesan terbaru
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error mengambil chat history: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMessages(String productName) async {
    try {
      String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception("User belum login");
      }

      // Mendapatkan referensi ke dokumen user_data > user_id > chat_profile > productName > chat
      final userDoc = FirebaseFirestore.instance
          .collection('user_data') // Koleksi utama user_data
          .doc(userId); // Gunakan user_id untuk menentukan dokumen pengguna

      final chatProfileCollection = userDoc.collection('chat_profile');
      final productChatCollection = chatProfileCollection
          .doc(productName)
          .collection('chat'); // Produk > chat

      // Query untuk mengambil pesan, urutkan berdasarkan timestamp
      final snapshot = await productChatCollection.orderBy('timestamp').get();
      print("Snapshot fetched: ${snapshot.docs.length} messages found.");

      if (snapshot.docs.isEmpty) {
        print("Tidak ada pesan ditemukan di Firestore.");
      }

      // Mengembalikan list pesan
      return snapshot.docs.map((doc) {
        return {
          'message': doc['message'],
          'is_user': doc['is_user'],
          'timestamp': doc['timestamp'].toDate().toString(),
        };
      }).toList();
    } catch (e) {
      print("Error getting messages: $e");
      return [];
    }
  }

  Future<void> insertMessage(
      String productName, String messageContent, bool isUserMessage) async {
    try {
      String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception("User belum login");
      }

      // Mendapatkan referensi ke dokumen user_data > user_id > chat_profile > productName > chat
      final userDoc = FirebaseFirestore.instance
          .collection('user_data') // Koleksi utama user_data
          .doc(userId); // Gunakan user_id untuk menentukan dokumen pengguna

      final chatProfileCollection = userDoc.collection('chat_profile');
      final productChatDoc = chatProfileCollection.doc(productName);

      // Periksa apakah produk sudah ada, jika tidak, tambahkan field 'name' ke produk
      final productDocSnapshot = await productChatDoc.get();
      if (!productDocSnapshot.exists) {
        // Jika produk belum ada, tambahkan field 'name' dengan nilai produk
        await productChatDoc.set(
            {
              'name': productName, // Menambahkan nama produk
            },
            SetOptions(
                merge:
                    true)); // Merge untuk menambahkan field tanpa menghapus data lain
      }

      final productChatCollection =
          productChatDoc.collection('chat'); // Sub-koleksi chat

      // Menyimpan pesan baru di sub-koleksi chat
      await productChatCollection.add({
        'message': messageContent,
        'is_user': isUserMessage ? 1 : 0,
        'timestamp': FieldValue.serverTimestamp(), // Menyimpan timestamp server
      });

      print('Pesan berhasil disimpan ke dalam chat profile: $productName');
    } catch (e) {
      print('Error saving message: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getChatProfiles() async {
    try {
      String userId =
          _auth.currentUser?.uid ?? ''; // Ambil ID pengguna yang sedang login
      if (userId.isEmpty) {
        print("User ID kosong");
        return [];
      }

      // Ambil data dari sub-koleksi 'chat_profile' milik user
      final userDoc = FirebaseFirestore.instance
          .collection('user_data') // Koleksi utama user_data
          .doc(userId); // Gunakan user_id untuk menentukan dokumen pengguna

      final chatProfileCollection = userDoc.collection('chat_profile');

      // Ambil daftar produk yang memiliki chat
      final chatProfileSnapshot = await chatProfileCollection.get();
      print(
          "Snapshot fetched: ${chatProfileSnapshot.docs.length} profiles found.");

      if (chatProfileSnapshot.docs.isEmpty) {
        print("Tidak ada chat profile ditemukan di Firestore.");
        return [];
      }

      List<Map<String, dynamic>> profiles = [];

      for (var profileDoc in chatProfileSnapshot.docs) {
        String productName = profileDoc['name'];

        // Ambil sub-koleksi 'chat' untuk produk ini
        final productChatCollection = profileDoc.reference.collection('chat');
        final chatSnapshot =
            await productChatCollection.orderBy('timestamp').get();

        if (chatSnapshot.docs.isEmpty) {
          print("Tidak ada pesan ditemukan untuk produk: $productName");
          continue;
        }

        // Menambahkan data chat ke dalam list
        profiles.add({
          'product_name': productName,
          'messages': chatSnapshot.docs.map((doc) {
            return {
              'message': doc['message'],
              'is_user': doc['is_user'] == 1 ? true : false,
              'timestamp': doc['timestamp'].toDate().toString(),
            };
          }).toList(),
        });
      }

      return profiles;
    } catch (e) {
      print("Error getting chat profiles: $e");
      return [];
    }
  }
}
