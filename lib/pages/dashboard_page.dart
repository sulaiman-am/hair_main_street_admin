import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street_admin/pages/create_admin.dart';
import 'package:hair_main_street_admin/pages/edit_user.dart';
import 'package:hair_main_street_admin/pages/orders_page.dart';
import 'package:hair_main_street_admin/pages/reviews_page.dart';
import 'package:hair_main_street_admin/pages/shopsPage.dart';
import 'package:hair_main_street_admin/pages/user_management.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 224, 139),
        title: const Text(
          "Hair Main Street Admin",
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.w700,
            color: Color(
              0xFFFF8811,
            ),
          ),
        ),
        actions: [
          const Text("Welcome admin"),
          PopupMenuButton<String>(
            icon: Icon(EvaIcons.edit),
            onSelected: (value) {
              if (value == 'editUser') {
                // Handle "Edit User" option
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditUserPage(),
                  ),
                );
              } else if (value == 'createAdmin') {
                // Handle "Create New Admin" option
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateAdminPage(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'editUser',
                  child: ListTile(
                    title: Text('Edit User'),
                    leading: Icon(EvaIcons.edit),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'createAdmin',
                  child: ListTile(
                    title: Text('Create New Admin'),
                    leading: Icon(Icons.person_add),
                  ),
                ),
              ];
            },
          ),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.notification_important))
        ],
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text("Dashboard Content"),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var colorHover = const Color.fromARGB(255, 200, 242, 237);
    return Drawer(
      child: Card(
        color: const Color.fromARGB(255, 255, 224, 139),
        shadowColor: const Color.fromARGB(255, 255, 224, 139),
        surfaceTintColor: const Color.fromARGB(255, 255, 224, 139),
        child: ListView(
          children: <Widget>[
            ListTile(
              hoverColor: colorHover,
              focusColor: const Color.fromARGB(255, 255, 224, 139),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardPage()),
                );
                // Navigate to the dashboard page (current page).
              },
            ),
            ListTile(
              hoverColor: colorHover,
              title: const Text("User Management"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagementPage()),
                );
              },
            ),
            ListTile(
              hoverColor: colorHover,
              title: const Text("Orders"),
              onTap: () {
                // Navigate to the user management page.
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersPage()),
                );
              },
            ),
            ListTile(
              hoverColor: colorHover,
              title: const Text("Shops"),
              onTap: () {
                Get.to(() => ShopsPage());
              },
            ),
            ListTile(
              hoverColor: colorHover,
              title: const Text("Reviews and ratings"),
              onTap: () {
                Get.to(() => ReviewPage());
                // Navigate to the user management page.
              },
            ),
            ListTile(
              hoverColor: colorHover,
              title: const Text("Report and analytics"),
              onTap: () {
                // Navigate to the user management page.
              },
            ),
            ListTile(
              hoverColor: colorHover,
              title: const Text("Payments"),
              onTap: () {
                // Navigate to the user management page.
              },
            ),
            // Add more drawer items for other sections
          ],
        ),
      ),
    );
  }
}
