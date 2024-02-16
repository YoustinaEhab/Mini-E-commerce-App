import 'package:dio/dio.dart';

class dio_helper{
  final Dio dio =Dio();

  Future<List> getProducts() async{
    try{
      Response response = await dio.get("https://dummyjson.com/products");
      if(response.statusCode == 200){
         return response.data["products"];
      }else{
        throw Exception('Failed to fetch products');
      }
    }catch(e){
      throw Exception('Failed to fetch products: $e');
    }
  }
}