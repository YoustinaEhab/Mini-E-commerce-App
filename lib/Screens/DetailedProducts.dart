import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:support_ecommerce_project/Constants/NavigationBar.dart';
import '../Constants/GlobalData.dart';
import '../Constants/Products.dart';
import 'package:flutter/material.dart';
import 'package:support_ecommerce_project/Dio/dio_helper.dart';

import '../data_provider/remote/firebasehelper.dart';
class DetailedProducts extends StatefulWidget {
  final Products product;

  const DetailedProducts({required this.product, super.key});

  @override
  State<DetailedProducts> createState() => _DetailedProductsState(product, key);
}

class _DetailedProductsState extends State<DetailedProducts> {
  List<Products> products = [];
  bool is_favourite = false;
  int favourite_count = 0;
  int selectedImage = 0;

  _DetailedProductsState(Products product, [Key? key]) {
    this.products = [product];
  }

  @override
  void initState() {
    super.initState();
    //getData();
  }

  Future getData() async {
    List ProductsList = await dio_helper().getProducts();
    products = Products.FetchData(ProductsList);
    //setState(() {});
  }

  void addToFavorites(Products product) {
    String currentUserId = FireBaseHelper().getCurrentUserId();
    setState(() {
      if (!GlobalData.favorites.contains(product)) {
        GlobalData.favorites.add(product);
        FireBaseHelper().addToFavorites(currentUserId, GlobalData.favorites.map((p) => p.id.toString()).toList());
      }
    });
  }
  void removeFromFavorites(Products product) {
    String currentUserId = FireBaseHelper().getCurrentUserId();
    setState(() {
      GlobalData.favorites.remove(product);
      FireBaseHelper().removeFromFavorites(currentUserId, GlobalData.favorites.map((p) => p.id.toString()).toList());
      product.ok = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isFavorite = false;
    for (var x in GlobalData.favorites) {
      if (widget.product.title == x.title) isFavorite = true;
    }
    return Scaffold(
      backgroundColor: Colors.indigo[50],
        appBar: AppBar(
          title: Text(widget.product.title, style: TextStyle(color: Colors.white,fontSize:20),),
          backgroundColor: Colors.indigo,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Navigation_Bar()),);
            },),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: LikeButton(
                size: 25,
                isLiked: isFavorite,
                onTap: (bool isLiked) async {
                  // Simulate a network request or some asynchronous operation
                  await Future.delayed(
                      Duration(seconds: 0));
                  if (isLiked) {
                    removeFromFavorites(widget.product);
                  } else {
                    addToFavorites(widget.product);
                  }
                  return !isLiked;
                },
                likeBuilder: (bool isLiked) {
                  return Icon(
                      isLiked? Icons.favorite : Icons.favorite_border,
                      color: isLiked
                          ? Colors.red
                          : Colors.grey,
                      size: 25,
                    );
                },
              ),
            ),
          ],
        ),

        body : Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 15,),
              SizedBox(
                width: 270,
                height: 270,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    widget.product.images[selectedImage],
                    width:270,
                    height: 270,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for(int index = 0; index < widget.product.images.length; index ++ )
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedImage = index;
                        });
                        },
                      child: Container(
                          margin: EdgeInsets.only(right: 15,top: 10),
                          padding: EdgeInsets.all(8),
                          height: 48, width: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: selectedImage == index ? Colors.indigo : Colors.transparent),
                          ),
                          child: Image.network(widget.product.images[index])),
                    ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                widget.product.title,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo
                ),
              ),
              SizedBox(height: 8),
              Text(
                " " + widget.product.price.toString() + " " + "\$ ",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.indigo,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Description:",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo
                ),
              ),
              SizedBox(height: 15),
              Text(
                widget.product.description,
                style: TextStyle(
                    fontSize: 15,color: Colors.indigoAccent),),
            ]
        )
     );
  }
}