import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapee_app/database/helper/validation_helper.dart';
import 'package:shapee_app/navigation/navigation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  DateTime? _selectedDate;
  bool _obscureText = true;
  bool _isLoading = false;

  // Future<bool> checkAndRequestStoragePermission() async {
  //   var status = await Permission.storage.status;

  //   if (status.isDenied) {
  //     // Minta izin
  //     status = await Permission.storage.request();
  //   }

  //   return status.isGranted;
  // }

  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();

    // Minta pengguna untuk memilih gambar dari galeri
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    } else {
      print("No image selected.");
    }
  }

  // Future<void> _showPermissionDeniedDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Izin Diperlukan'),
  //         content: const Text(
  //             'Aplikasi ini memerlukan akses ke penyimpanan untuk memilih gambar profil.'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Buka Pengaturan'),
  //             onPressed: () async {
  //               Navigator.of(context).pop(); // Tutup dialog
  //               // Buka pengaturan aplikasi
  //               await openAppSettings();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Tutup'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<String?> _uploadProfileImage() async {
    if (_profileImage == null) {
      print("No profile image selected.");
      return null; // Tidak ada gambar yang dipilih
    }

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${_emailController.text}.jpg');

      // Log sebelum mengupload
      print("Uploading image to Firebase Storage: ${storageRef.fullPath}");

      await storageRef.putFile(_profileImage!);

      // Log setelah upload
      print("Upload successful!");

      String downloadUrl = await storageRef.getDownloadURL();
      print("Image URL: $downloadUrl");

      return downloadUrl;
    } catch (e) {
      print("Error uploading profile image: $e");
      return null;
    }
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    // Validasi input
    String? emailError = ValidationHelper.validateEmail(_emailController.text);
    String? passwordError =
        ValidationHelper.validatePassword(_passwordController.text);
    String? fullNameError = ValidationHelper.validateField(
        _fullNameController.text, "Nama Lengkap");
    String? usernameError =
        ValidationHelper.validateField(_usernameController.text, "Username");

    // Tampilkan pesan kesalahan jika ada
    if (emailError != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(emailError)));
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (passwordError != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(passwordError)));
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (fullNameError != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(fullNameError)));
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (usernameError != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(usernameError)));
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      String? profileImageUrl = await _uploadProfileImage();

      await FirebaseFirestore.instance
          .collection('user_data')
          .doc(userCredential.user!.uid)
          .set({
        'user_email': _emailController.text,
        'full_name': _fullNameController.text,
        'username': _usernameController.text,
        'date_of_birth': _selectedDate?.toIso8601String(),
        'profile_image': profileImageUrl,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => NavigationPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      String errorMessage;

      // Tangani kesalahan berdasarkan kode kesalahan
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'Email sudah terdaftar.';
            break;
          case 'invalid-email':
            errorMessage = 'Format email tidak valid.';
            break;
          case 'weak-password':
            errorMessage = 'Password terlalu lemah.';
            break;
          default:
            errorMessage = 'Registrasi gagal. Silakan coba lagi.';
        }
      } else {
        errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    print("Avatar tapped");
                    _selectImage();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(Icons.add_a_photo, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Tanggal Lahir'
                            : 'Tanggal Lahir: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        child: const Text('Registrasi'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sudah punya akun? '),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
