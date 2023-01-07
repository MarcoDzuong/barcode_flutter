import 'package:http/http.dart' as http;

class ProductController {

  Future<void> createProduct() async {

    var url = Uri.https('example.com', 'whatsit/create');
    var response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});

    

  }


}