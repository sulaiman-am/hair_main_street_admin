import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street_admin/controllers/userController.dart';
import 'package:hair_main_street_admin/models/userModel.dart';
import 'package:string_validator/string_validator.dart' as validator;

class CreateAdminPage extends StatefulWidget {
  const CreateAdminPage({Key? key});

  @override
  _CreateAdminPageState createState() => _CreateAdminPageState();
}

class _CreateAdminPageState extends State<CreateAdminPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserController userController = UserController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email, password, name, phone, address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (!validator.isEmail(value!)) {
                    return "Enter a valid Email";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    email = value!;
                  });
                  return null;
                },
              ),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                onChanged: (value) {
                  phone = value;
                },
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
                onChanged: (value) {
                  address = value;
                },
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Password";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters long";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    password = value!;
                    //return null;
                  });
                  return null;
                },
              ),
              TextFormField(
                controller: confirmpasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                validator: (value) {
                  debugPrint(password);
                  if (value != password) {
                    return "Password does not match";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  bool validated = formKey.currentState!.validate();
                  if (validated) {
                    formKey.currentState!.save();
                    userController.isLoading.value = true;
                    userController.createUser(
                        email, password, name, phone, address);
                  }
                },
                child: Text('Create Admin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
