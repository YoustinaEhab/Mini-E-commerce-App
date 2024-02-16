import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:support_ecommerce_project/Dio/dio_helper.dart';
import 'package:support_ecommerce_project/Screens/SignIn.dart';
import 'package:support_ecommerce_project/data_provider/remote/firebasehelper.dart';
import '../Constants/Products.dart';
import 'DetailedProducts.dart';
import '../Constants/GlobalData.dart';
import 'package:like_button/like_button.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Products> items =[];
  TextEditingController searchController = TextEditingController();
  List<Products> filtered_items = [];
  //List<Products> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    getData();
    //fetchFavorites();
  }

  Future getData() async {
    List itemsList = await dio_helper().getProducts();
    items = Products.FetchData(itemsList);
    setState(() {});
  }

  void filterItems(String query) {
    filtered_items = items.where((item) {
      return item.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {});
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

  // Future<void> fetchFavorites() async {
  //   String userId = FireBaseHelper().getCurrentUserId();
  //   List<String> favoriteProductIds = await FireBaseHelper().getFavorites(userId);
  //   List<Products> fetchedFavorites = items.where((product) => favoriteProductIds.contains(product.id.toString())).toList();
  //   setState(() {
  //     GlobalData.favorites = fetchedFavorites;
  //   });
  // }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo,
          title: const Text(
            "Home",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            IconButton(
              onPressed: () async{
                await FireBaseHelper().signout();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SignIn();
              }));
              },
              icon: const Icon(Icons.logout),
              color: Colors.white,
            ),
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(
                width: 360,
                height: 40,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    filterItems(value);
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.indigoAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.indigo, width: 2),
                    ),
                    contentPadding: EdgeInsets.all(5.0),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'What are you looking for?',
                    hintStyle: TextStyle(
                      color: Colors.indigo,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                child: items.length == 0
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.indigo),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          // itemWidth / itemHeight
                          childAspectRatio: 0.82,
                        ),
                        itemCount: filtered_items.length > 0
                            ? filtered_items.length
                            : items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final product = filtered_items.length > 0
                              ? filtered_items[index]
                              : items[index];
                          bool isFavorite = false;
                          for (var x in GlobalData.favorites) {
                            if (product.title == x.title) isFavorite = true;
                          }

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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0, top: 10.0),
                                            child: Image.network(
                                              product.thumbnail,
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: LikeButton(
                                            size: 20,
                                            isLiked: isFavorite,
                                            onTap: (bool isLiked) async {
                                              // Simulate a network request or some asynchronous operation
                                              await Future.delayed(
                                                  Duration(seconds: 0));
                                              if (isLiked) {
                                                removeFromFavorites(product);
                                              } else {
                                                addToFavorites(product);
                                              }
                                              return !isLiked;
                                            },
                                            likeBuilder: (bool isLiked) {
                                              return Icon(
                                                isLiked? Icons.favorite : Icons.favorite_border,                                                color: isLiked
                                                    ? Colors.red
                                                    : Colors.grey,
                                                size: 20,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6.0, right: 6.0),
                                        child: Text(
                                          product.title,
                                          //overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.indigo),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6.0, right: 6.0),
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
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 6.0),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "\$ " + product.price.toString(),
                                          //overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              color: Colors.indigo),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
              )
            ],
          ),
        ),
      ),
    );
  }

}
