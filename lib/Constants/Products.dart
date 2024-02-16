class Products{
  final int id;
  final String title;
  final String description;
  final int price;
  final String thumbnail;
  final List<String> images;

  bool ok;
  Products({required this.id, required this.title, required this.description, required this.price, required this.thumbnail,required this.ok,required this.images});

  static List<Products> FetchData(List products){
    List<Products> productsList = [];
    for(var product in products){
      if(product["id"] == null || product["title"] == null || product["description"] == null || product["price"] == null || product["thumbnail"] == null){
        continue;
      }
      productsList.add(
        Products(id: product["id"],title: product["title"], description: product["description"], price: product["price"], thumbnail: product["thumbnail"],ok:false,images: List<String>.from(product["images"]))
      );
    }
    return productsList;
  }
}