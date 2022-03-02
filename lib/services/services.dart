import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/states/add_news.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Services {
  Services();

  // String enviroment = 'https://paysave.me';
  String enviroment = 'https://topfan.topnews.co.th/api/v1/topnews-test/';

  static Future<http.Response> getListNews() async {
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    };

    return http.get(
      Uri.parse('https://topfan.topnews.co.th/api/v1/topnews-test/news'),
      headers: headers,
    );
  }

  static Future<http.Response> getNewsbyId(String id) async {
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    };

    return http.get(
      Uri.parse('https://topfan.topnews.co.th/api/v1/topnews-test/news/$id'),
      headers: headers,
    );
  }

  static Future<http.Response> getCategoriesList() async {
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    };

    return http.get(
      Uri.parse('https://topfan.topnews.co.th/api/v1/topnews-test/categories'),
      headers: headers,
    );
  }

  static Future<http.Response> addNews(
      String title, String description, List category) async {
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    };
    var categories;
    if (category.length > 1) {
      categories = category.join(",");
    } else {
      categories = category.join("");
    }

    var body = jsonEncode(<String, dynamic>{
      "title": title,
      "category": categories,
      "description": description,
    });

    return http.post(
      Uri.parse('https://topfan.topnews.co.th/api/v1/topnews-test/news'),
      headers: headers,
      body: body,
    );
  }

  static Future<http.Response> editNews(
      String id, String title, String description, List category) async {
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    };

    var categories;
    if (category.length > 1) {
      categories = category.join(",");
    } else {
      categories = category.join("");
    }

    var body = jsonEncode(<String, dynamic>{
      "title": title,
      "category": categories,
      "description": description,
    });

    return http.put(
      Uri.parse('https://topfan.topnews.co.th/api/v1/topnews-test/news/$id'),
      headers: headers,
      body: body,
    );
  }

  static Future<http.Response> deleteNews(String id) async {
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    };

    return http.delete(
      Uri.parse('https://topfan.topnews.co.th/api/v1/topnews-test/news/$id'),
      headers: headers,
    );
  }
}
