import 'package:flutter/cupertino.dart';
import '../Constants/GlobalData.dart';
import '../Constants/Products.dart';
import 'package:flutter/material.dart';
import 'DetailedProducts.dart';

class Favorites extends StatefulWidget {

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Products> favoriteProducts = [];
  List<Products> allProducts = [];

  @override
  void initState() {
    super.initState();
    // fetchFavorites();
  }

  // Future<void> fetchFavorites() async {
  //   String userId = FireBaseHelper().getCurrentUserId();
  //   List<String> favoriteProductIds = await FireBaseHelper().getFavorites(userId);
  //   List<Products> fetchedFavorites = allProducts.where((product) => favoriteProductIds.contains(product.id.toString())).toList();
  //   setState(() {
  //     favoriteProducts = fetchedFavorites;
  //   });
  // }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Favorites"),
        backgroundColor: Colors.indigo,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.82,
        ),
        itemCount: GlobalData.favorites.length,
        itemBuilder: (BuildContext context, int index) {
          final product = GlobalData.favorites[index];

          return GestureDetector(
              onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => DetailedProducts(product: product)));
          },
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo,
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                        child: Image.network(product.thumbnail, width: 100, height: 100),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red),
                      iconSize: 20,
                      onPressed: () {
                        setState(() {
                          GlobalData.favorites.remove(product);
                          product.ok=false;
                        });
                        },
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                    child: Text(
                      product.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                  child: Text(
                    product.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black26,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 6.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "\$ " + product.price.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
          );
        },
      ),
    );
  }

}

