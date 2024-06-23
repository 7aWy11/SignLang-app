import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:singlanguage/pages/auth/login.dart';
import 'package:singlanguage/pages/main/complete_profile.dart';
import 'package:singlanguage/pages/main/home.dart';
import 'package:http/http.dart' as http;

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

  Future<void> saveData(String FirstName, String LastName, String email,
      String role, String phone) async {
    await storage.write(key: "first_name", value: FirstName);
    await storage.write(key: "last_name", value: LastName);
    await storage.write(key: "email", value: email);
    await storage.write(key: "role", value: role);
    await storage.write(key: "phone", value: phone);
  }

  Future<void> deleteData() async {
    await storage.delete(key: "first_name");
    await storage.delete(key: "last_name");
    await storage.delete(key: "email");
    await storage.delete(key: "role");
    await storage.delete(key: "phone");
  }

  AuthController(context) {
    this._context = context;
    httpClient.baseUrl = 'http://10.0.2.2:8000/api/v1/auth';
    httpClient.addRequestModifier<void>((request) async {
      final token = await getToken();
      if (token != null) request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      return request;
    });

    httpClient.addResponseModifier<void>((request, response) async {
      if (response.statusCode == HttpStatus.unauthorized) {
        print("HttpStatus.unauthorized");
        final newToken = await refreshToken();
        print("newToken: $newToken\n");
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

  Future<String?> refreshToken() async {
    try {
      final response = await post("/refresh", []);
      if (response.statusCode == HttpStatus.ok) {
        final newToken = response.body['token'];
        print("refreshToken: $newToken\n");
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
        if (user['first_name'] != null &&
            user['last_name'] != null &&
            user['email'] != null &&
            user['role'] != null &&
            user['phone'] != null) {
          await saveData(user['first_name'], user['last_name'], user['email'],
              user['role'], user['phone']);
          Navigator.pushReplacementNamed(_context, HomeScreen.routName);
        } else {
          MessageBoxonConfirm(_context, "Error",
              "User data is incomplete, do you want to complete it?", () {
            Navigator.pushReplacementNamed(
                _context, CompleteProfileScreen.routName);
          });
        }
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

  Future<void> updateProfile(String firstName, String lastName, String phone,
      bool navigateToHome) async {
    try {
      final response = await post('/user/update/profile', {
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
      });
      if (response.statusCode == HttpStatus.ok) {
        final user = response.body['user'];
        await saveData(user['first_name'], user['last_name'], user['email'],
            user['role'], user['phone']);
        if (navigateToHome == true) {
          Get.snackbar("Success", "Profile updated Successfully");
          Navigator.pushReplacementNamed(_context, HomeScreen.routName);
        } else {
          Get.snackbar("Success", "Profile updated Successfully");
          Navigator.pop(_context);
        }
      } else {
        showCupertinoDialogReuse(_context, "Error", response.body['error']);
      }
    } catch (e) {
      print('Update profile failed: $e');
      final token = await storage.read(key: "token");
      print(token);
      showCupertinoDialogReuse(_context, "Error", 'Update profile failed');
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final response = await post('/user/update/password', {
        'current_password': currentPassword,
        'new_password': newPassword,
      });
      if (response.statusCode == HttpStatus.ok) {
        final message = response.body['message'];
        Get.snackbar("Success", message);
        Navigator.pop(_context);
      } else {
        showCupertinoDialogReuse(_context, "Error", response.body['error']);
        print(response.body['error']);
      }
    } catch (e, stacktrace) {
      print('Change password failed: $e');
      print('Stacktrace: ' + stacktrace.toString());
      showCupertinoDialogReuse(_context, "Error", 'Change password failed');
    }
  }

  Future<dynamic> getUserData() async {
    try {
      final response = await post("/user", {});
      if (response.statusCode == HttpStatus.ok) {
        print(response.body);
        return response.body;
      }
    } catch (e) {
      showCupertinoDialogReuse(_context, "Error", 'Something wrong happened!');
    }
  }

  Future<void> saveStatusesData(String websiteStatus, String aiModelStatus) async {
    await storage.write(key: "websiteStatus", value: websiteStatus);
    await storage.write(key: "aiModelStatus", value: aiModelStatus);
  }

  Future<void> getStatuses() async {
    try {
      final response = await get('/statuses');

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> data = response.body;
        // final websiteStatus = data[0]['status'];
        // final aiModelStatus = data[1]['status'];
        await saveStatusesData(data[0]['status'], data[1]['status']);
      } else {
        showCupertinoDialogReuse(_context, "Error", 'Failed to load statuses!');
      }
    } catch (e) {
      showCupertinoDialogReuse(_context, "Error", 'Something went wrong!');
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