import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soaqtwo/src/core/models/cardProduct.dart';
import 'package:soaqtwo/src/core/models/cardProductItem.dart';
import 'package:soaqtwo/src/core/models/favourite.dart';
import 'package:soaqtwo/src/core/models/product.dart';
import 'package:http/http.dart' as http;
import '../environment.dart';
import 'package:soaqtwo/src/core/models/faild_request.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _nexusProducts;
  List<Product> _keellsProducts;
  List<Product> _favouriteProducts;
  List<CardProduct> _cardProducts;

  Product selectedProduct;
  Favourite _favourite;
  CardProductItem _cardProductItem;

  List<Product> get nexusProducts => _nexusProducts;

  List<Product> get keellsProducts => _keellsProducts;

  List<CardProduct> get cardProducts => _cardProducts;

  List<Product> get favouriteProducts => _favouriteProducts;

  Favourite get favourite => _favourite;

  CardProductItem get cardProductItem => _cardProductItem;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<dynamic> nexusDeals() async {
    _isLoading = true;
    notifyListeners();
    print('Starting request');

    http.Response response = await http.get(Environment.productDeal + "nexus",
        headers: Environment.requestHeader);
    print('Completed request');
    print('respond data : ${response.body}');

    Map<String, dynamic> res = json.decode(response.body);
    var results;
    if (res['code'] == 200) {
      _nexusProducts = [];
      res['data'].forEach((v) {
        _nexusProducts.add(new Product.fromJson(v));
      });
      results = true;
    } else {
      results =
          FailedRequest(code: 400, message: res['message'], status: false);
    }
    _isLoading = false;
    notifyListeners();
    return results;
  }

  Future<dynamic> keellsDeals() async {
    _isLoading = true;
    notifyListeners();
    print('Starting request');

    http.Response response = await http.get(Environment.productDeal + "keells",
        headers: Environment.requestHeader);
    print('Completed request');
    print('respond data : ${response.body}');

    Map<String, dynamic> res = json.decode(response.body);
    var results;
    if (res['code'] == 200) {
      _keellsProducts = [];
      res['data'].forEach((v) {
        _keellsProducts.add(new Product.fromJson(v));
      });
      results = true;
    } else {
      results =
          FailedRequest(code: 400, message: res['message'], status: false);
    }
    _isLoading = false;
    notifyListeners();
    return results;
  }

  Future<dynamic> setFavourite(userId, productId) async {
    final Map<String, dynamic> body = {
      'productId': productId,
      'userId': userId
    };

    _isLoading = true;
    notifyListeners();
    print('Starting request');
    http.Response response = await http.post(Environment.setFavourite,
        body: json.encode(body), headers: Environment.requestHeader);
    print('Completed request');

    print(' response : ${response.body}');
    Map<String, dynamic> res = json.decode(response.body);
    var results;
    if (res['code'] == 200) {
      _favourite = Favourite.fromJson(res['data']);
      results = true;
    } else {
      results =
          FailedRequest(code: 400, message: res['message'], status: false);
    }
    _isLoading = false;
    notifyListeners();
    return results;
  }

  Future<dynamic> getFavouriteProducts(String userId) async {
    final Map<String, dynamic> body = {
      'id': userId,
    };

    _isLoading = true;
    notifyListeners();
    print('Starting request');
    http.Response response = await http.post(Environment.favouriteProducts,
        body: json.encode(body), headers: Environment.requestHeader);
    print('Completed request');

    print(' response : ${response.body}');
    Map<String, dynamic> res = json.decode(response.body);
    var results;
    if (res['code'] == 200) {
      _favouriteProducts = [];

      if(res['data'] != '[]'){
        res['data'].forEach((v) {
          _favouriteProducts.add(new Product.fromJson(v));
        });
      }

      results = true;
    } else {
      results =
          FailedRequest(code: 400, message: res['message'], status: false);
    }
    _isLoading = false;
    notifyListeners();
    return results;
  }

  Future<dynamic> getCardProducts(String userId) async {
    final Map<String, dynamic> body = {
      'id': userId,
    };

    _isLoading = true;
    notifyListeners();
    print('Starting request');
    http.Response response = await http.post(Environment.cardProducts,
        body: json.encode(body), headers: Environment.requestHeader);
    print('Completed request');

    print(' response : ${response.body}');
    Map<String, dynamic> res = json.decode(response.body);
    var results;
    if (res['code'] == 200) {
      _cardProducts = [];
      if (res['data'] != '[]') {
        res['data'].forEach((v) {
          _cardProducts.add(new CardProduct.fromJson(v));
        });
      }

      results = true;
    } else {
      results =
          FailedRequest(code: 400, message: res['message'], status: false);
    }
    _isLoading = false;
    notifyListeners();
    return results;
  }

  Future<dynamic> addToCard(CardProductItem cardProductItem) async {
    final Map<String, dynamic> body = cardProductItem.toJson();
    _isLoading = true;
    notifyListeners();
    print('Starting request');

    http.Response response = await http.post(Environment.addCardProducts,
        body: json.encode(body), headers: Environment.requestHeader);
    print('Completed request');
    print("body " + response.body);

    Map<String, dynamic> res = json.decode(response.body);
    var results;
    if (res['code'] == 200) {
      _cardProductItem = CardProductItem.fromJson(res['data']);
      results = true;
    } else {
      results =
          FailedRequest(code: 400, message: res['message'], status: false);
    }
    _isLoading = false;
    notifyListeners();
    return results;
  }
}
