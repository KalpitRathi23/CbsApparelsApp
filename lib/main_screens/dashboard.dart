// ignore_for_file: unused_import, use_build_context_synchronously

import 'package:cbs_apparels/dashboard_components/edit_business.dart';
import 'package:cbs_apparels/dashboard_components/manage_products.dart';
import 'package:cbs_apparels/dashboard_components/my_store.dart';
import 'package:cbs_apparels/dashboard_components/supp_balance.dart';
import 'package:cbs_apparels/dashboard_components/supp_statics.dart';
import 'package:cbs_apparels/dashboard_components/supp_orders.dart';
import 'package:cbs_apparels/minor_screens/visit_store.dart';
import 'package:cbs_apparels/widgets/alert_dialog.dart';
import 'package:cbs_apparels/widgets/appbar_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

List<String> label = [
  'my store',
  'orders',
  'edit profile',
  'manage',
  'balance',
  'statics'
];
List<Widget> pages = [
  VisitStore(suppId: FirebaseAuth.instance.currentUser!.uid),
  const SupplierOrders(),
  const EditBusiness(),
  const ManageProducts(),
  const BalanceScreen(),
  const StaticsScreen(),
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Dashboard',
        ),
        actions: [
          IconButton(
            onPressed: () {
              MyAlertDilaog.showMyDialog(
                context: context,
                title: 'Log Out',
                content: 'Are you sure to log out ?',
                tabNo: () {
                  Navigator.pop(context);
                },
                tabYes: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/welcome_screen');
                },
              );
            },
            icon: const Icon(Icons.logout),
            color: Colors.black,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          crossAxisCount: 2,
          children: List.generate(6, (index) {
            return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => pages[index]));
              },
              child: Card(
                elevation: 20,
                shadowColor: Colors.purpleAccent.shade200,
                color: Colors.blueGrey.withOpacity(0.7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      icons[index],
                      size: 50,
                      color: Colors.yellow,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        label[index].toUpperCase(),
                        style: const TextStyle(
                            fontSize: 23,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                            fontFamily: 'Open'),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
