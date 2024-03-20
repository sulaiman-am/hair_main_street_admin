import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street_admin/controllers/userController.dart';
import 'package:hair_main_street_admin/models/userModel.dart';
import 'package:hair_main_street_admin/pages/dashboard_page.dart';

class UserManagementPage extends StatelessWidget {
  UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    userController.users.bindStream(userController.fetchMyusers());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 224, 139),
        title: Text("User Management"),
      ),
      body: Obx(
        () => userController.users.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      UserListTile(
                        name:
                            "${userController.users.value[index]!.fullname ?? "No name"}",
                        userType:
                            "${userController.users.value[index]!.getUserType()}", // add parentheses to getUserType

                        onEdit: () {
                          // Handle edit action
                          print("Edit John Doe");
                        },
                        onDelete: () {
                          // Handle delete action
                          print("Delete John Doe");
                        },
                      ),
                      const Divider(),
                    ],
                  );
                },
                itemCount: userController.users.length,
                // User List
                // Add more user list tiles as needed
              ),
      ),
      drawer: AppDrawer(), // Place the drawer on the left side
      persistentFooterButtons: const [
        // Empty list to keep the drawer permanently open
      ],
    );
  }
}

class UserListTile extends StatelessWidget {
  final String name;
  final String userType;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  UserListTile({
    required this.name,
    required this.userType,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    var colorHover = const Color.fromARGB(255, 200, 242, 237);
    return Card(
      child: ListTile(
        dense: true,
        focusColor: colorHover,
        //tileColor: colorHover,
        // hoverColor: colorHover,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.all(5),
        title: Text(name),
        subtitle: Text("User Type: $userType"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
