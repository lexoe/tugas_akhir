import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tugas_akhir/models/orders_model.dart';

class OrdersProvider with ChangeNotifier {
  static List<OrderModel> _orders = [];
  List<OrderModel> get getOrders {
    return _orders;
  }

  Future<void> fetchOrders() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? _user = _auth.currentUser;
    var _uid = _user!.uid;
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: _uid)
          .get()
          .then((QuerySnapshot ordersSnapshot) {
        _orders = [];
        // _orders.clear();
        ordersSnapshot.docs.forEach((element) {
          _orders.insert(
            0,
            OrderModel(
              orderId: element.get('orderId'),
              userId: element.get('userId'),
              productId: element.get('productId'),
              userName: element.get('userName'),
              price: element.get('price').toString(),
              imageUrl: element.get('imageUrl'),
              quantity: element.get('quantity').toString(),
              orderDate: element.get('orderDate'),
            ),
          );
        });
      });
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Printing error while fetching order $error');
      }
    }
  }
}
