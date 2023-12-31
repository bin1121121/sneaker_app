import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sneaker_app/service/firestore_service/firestore_user/firestore_user.dart';

import '../../../models/cart_data.dart';

class FirestoreCart {
  final _users = FirebaseFirestore.instance.collection('users');

  Future<void> addCart(
      CartData cart, String idProduct, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await _users
          .doc(FirestoreUser.idUser)
          .collection('cart')
          .get()
          .then((querySnapshot) {
        var idCart = querySnapshot.docs.firstWhere((snapshot) =>
            snapshot.data()["idProduct"] == idProduct &&
            snapshot.data()["size"] == cart.size);
        if (idCart.exists) {
          cart.quantity += int.parse(idCart.data()["quantity"].toString());
          _users
              .doc(FirestoreUser.idUser)
              .collection("cart")
              .doc(idCart.id)
              .update(cart.toJson());
        }
      });
    } catch (e) {
      _users.doc(FirestoreUser.idUser).collection("cart").add(cart.toJson());
    }

    Navigator.pop(context);
  }

  List<CartData>? getCarts(
      List<QueryDocumentSnapshot<Map<String, dynamic>>>? docs) {
    List<CartData>? carts;
    carts = docs
        ?.map((documentSnapshot) => CartData.fromJson(documentSnapshot.data()))
        .toList();

    return carts;
  }

   List<String>? getIds(
      List<QueryDocumentSnapshot<Map<String, dynamic>>>? docs) {
    List<String>? ids;
    ids = docs
        ?.map((documentSnapshot) => documentSnapshot.id)
        .toList();

    return ids;
  }

  Future<void> updateCheckedItemOfCart(String idCart, bool isChecked) async {
    await _users
        .doc(FirestoreUser.idUser)
        .collection("cart")
        .doc(idCart)
        .update({"isSelected": isChecked});
  }

  Future deleteItemOfCart(String idItem) async {
    
    await _users
        .doc(FirestoreUser.idUser)
        .collection("cart")
        .doc(idItem)
        .delete();
    
  }

  void incrementItem(String idCart, int value, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    await _users
        .doc(FirestoreUser.idUser)
        .collection("cart")
        .doc(idCart)
        .update({"quantity": (++value)});
    Navigator.pop(context);
  }

  void decrementItem(String idCart, int value, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    await _users
        .doc(FirestoreUser.idUser)
        .collection("cart")
        .doc(idCart)
        .update({"quantity": (--value)});
    Navigator.pop(context);
  }
}
