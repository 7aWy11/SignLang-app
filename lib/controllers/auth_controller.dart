import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:singlanguage/pages/auth/login.dart';
import 'package:singlanguage/pages/main/complete_profile.dart';
import 'package:singlanguage/pages/main/home.dart';

import '../helper/shared.dart';

class AuthController extends GetConnect {
  final storage = FlutterSecureStorage();
  late var _context = null;

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: "token", value: token);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: "token");
  }

  Future<void> saveData(String FirstName , String LastName , String email , String role) async {
    await storage.write(key: "first_name", value: FirstName);
    await storage.write(key: "last_name", value: LastName);
    await storage.write(key: "email", value: email);
    await storage.write(key: "role", value: role);
  }

  Future<void> deleteData() async {
    await storage.delete(key: "first_name");
    await storage.delete(key: "last_name");
    await storage.delete(key: "email");
    await storage.delete(key: "role");
  }

  AuthController(context) {
    this._context = context;
    httpClient.baseUrl = 'http://10.0.2.2:8000/api/v1/auth';
    httpClient.addRequestModifier<void>((request) async {
      final token = await getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    httpClient.addResponseModifier<void>((request, response) async {
      if (response.statusCode == HttpStatus.unauthorized) {
        final newToken = await refreshToken();
        if (newToken != null) {
          await saveToken(newToken);
          request.headers['Authorization'] = 'Bearer $newToken';
          return await httpClient.request(
              request.method, request.url as String);
        } else {
          Get.offAllNamed('/login');
        }
      }
      return response;
    });
  }

  @override
  void onInit() {
    httpClient.baseUrl = 'http://10.0.2.2:8000/api/v1/auth';
    httpClient.addRequestModifier<void>((request) async {
      final token = await getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    httpClient.addResponseModifier<void>((request, response) async {
      if (response.statusCode == HttpStatus.unauthorized) {
        final newToken = await refreshToken();
        if (newToken != null) {
          await saveToken(newToken);
          request.headers['Authorization'] = 'Bearer $newToken';
          return await httpClient.request(
              request.method, request.url as String);
        } else {
          Get.offAllNamed('/login');
        }
      }
      return response;
    });

    super.onInit();
  }

  Future<String?> refreshToken() async {
    try {
      final response = await post("/refresh", null);
      if (response.statusCode == HttpStatus.ok) {
        final newToken = response.body['token'];
        return newToken;
      } else {
        await deleteToken();
        return null;
      }
    } catch (e) {
      print('Token refresh failed: $e');
      return null;
    }
  }

  Future<Response?> fetchData(String endpoint) async {
    try {
      final response = await get(endpoint);
      return response;
    } catch (e) {
      print('API call failed: $e');
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response =
          await post('/login', {'email': email, 'password': password});
      if (response.statusCode == HttpStatus.ok) {
        final token = response.body['token'];
        await saveToken(token);

        final user = response.body['user'];
        await saveData(user['first_name'],user['last_name'],user['email'],user['role']);

        Navigator.pushReplacementNamed(
            _context, HomeScreen.routName);
        //Get.offAllNamed('/home');
      } else {
        showCupertinoDialogReuse(_context, "Error", 'Login failed');
        //Get.snackbar('Error', 'Login failed');
      }
    } catch (e) {
      print('Login failed: $e');
      showCupertinoDialogReuse(_context, "Error", 'Login failed');
      //Get.snackbar('Error', 'Login failed');
    }
  }

  Future<void> register(String email, String password) async {
    try {
      final response =
          await post('/register', {'email': email, 'password': password});
      if (response.statusCode == HttpStatus.ok) {
        final token = response.body['token'];
        await saveToken(token);
        //Get.offAllNamed('/complete_profile');
        Navigator.pushReplacementNamed(
            _context, CompleteProfileScreen.routName);
        showSnackBar(_context, "Successfully Registration", Colors.green);
      } else {
        showCupertinoDialogReuse(_context, "Error", response.body['error']);
      }

      print(response.body);
    } catch (e) {
      print('Registration failed: $e');
      Get.snackbar('Error', 'Registration failed');
    }
  }

  Future<void> updateProfile(
      String firstName, String lastName, String phone) async {
    try {
      final response = await post('/user/update/profile', {
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
      });
      if (response.statusCode == HttpStatus.ok) {
        final user = response.body['user'];
        await saveData(user['first_name'],user['last_name'],user['email'],user['role']);
        showSnackBar(_context, "Success Profile updated", Colors.green);
        Navigator.pushReplacementNamed(_context, HomeScreen.routName);
      } else {
        showCupertinoDialogReuse(_context, "Error", response.body['error']);
      }
    } catch (e) {
      print('Update profile failed: $e');
      showCupertinoDialogReuse(_context, "Error", 'Update profile failed');
    }
  }

  Future<void> logout() async {
    await deleteToken();
    await deleteData();
    Navigator.pushReplacementNamed(_context, LoginScreen.routName);
  }

  Future<bool> isAuthed() async {
    return await getToken() != null;
  }
}
