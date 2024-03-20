import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  UserController userController = Get.put(UserController());
  RxString username = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString address = ''.obs;

  void updateUser(
      String newUsername, String newPhoneNumber, String newAddress) {
    // Mocking a server request (replace with your actual update logic)
    bool isUpdateSuccessful = true; // Set this based on your update logic

    if (isUpdateSuccessful) {
      // Update user information
      username.value = newUsername;
      phoneNumber.value = newPhoneNumber;
      address.value = newAddress;

      // Show success snackbar
      Get.snackbar(
        'Success',
        'User information has been updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }
}

class EditUserPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  EditUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://media.istockphoto.com/id/1495088043/vector/user-profile-icon-avatar-or-person-icon-profile-picture-portrait-symbol-default-portrait.jpg?s=612x612&w=0&k=20&c=dhV2p1JwmloBTOaGAtaA3AW1KSnjsdMt7-U_3EZElZ0='),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              enabled: false,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: addressController,
              decoration:
                  const InputDecoration(labelText: 'Address or Zip Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Use Get to find the UserController instance and call updateUser method
                Get.find<UserController>().updateUser(
                  usernameController.text,
                  phoneNumberController.text,
                  addressController.text,
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
