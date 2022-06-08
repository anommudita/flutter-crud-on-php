import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HttpProvider with ChangeNotifier {
  // mula - mula data kosong
  Map<String, dynamic> _data = {};

  // lalu datanya diisikan atau dikembalikan
  // return dan menggunakan teknik tenary operator
  Map<String, dynamic> get data => _data;

  // tentukan panjang data
  int get jumlahData => _data.length;

  // late Uri url;
  // method Post
  void connectAPI(String nim, nama, jk, alamat, jurusan) async {
    // connect ke databae
    Uri url = Uri.parse("http://localhost/restapi_server/index.php");

    // hhtp bisa get,post, pust nanti sesuaikan saja dengan database anda
    // memanggil object http

    var hasilResponse = await http.post(url, body: {
      "nim": nim,
      "nama": nama,
      "jk": jk,
      "alamat": alamat,
      "jurusan": jurusan,
    });

    if (hasilResponse.statusCode == 201) {
      _data = (json.decode(hasilResponse.body));

      // untuk terjadinya perubahan di page home_stateful.dart
      notifyListeners();
      print("berhasil");
    } else {
      print("gagal");
      print(hasilResponse.statusCode);
    }
  }

  // method get data
  void GetData() async {
    Uri url = Uri.parse("http://localhost/restapi_server/index.php");
    var hasilResponse = await http.get(url);

    if (hasilResponse.statusCode == 200) {
      _data = (json.decode(hasilResponse.body));
      notifyListeners();
      print("berhasil get");
    } else {
      print("gagal get");
    }
  }

  // method delete
  void deleteData(
    String id,
  ) async {
    Uri url = Uri.parse("http://localhost/restapi_server/index.php?id=" + id);
    var hasilResponse = await http.delete(url);

    // karena delete tidak menghasilkan respon maka code 204 sebagai patokan apakah data tersebut sudah
    // atau tidak
    // print(hasilResponse.statusCode);

    if (hasilResponse.statusCode == 204) {
      print("Tidak Ada Data");
      // menghapus data dengan wadah kosong!
      _data = {};
      notifyListeners();
      // No Content == Data Berhasuk Dihapus!
      // handlingStatusCode(context, "Berhasil dihapus!");
    }
  }

  // method update
  void updateData(String id, nim, nama, jk, alamat, jurusan) async {
    // connect ke databae
    Uri url = Uri.parse("http://localhost/restapi_server/index.php?id=" + id);

    // hhtp bisa get,post, pust nanti sesuaikan saja dengan database anda
    // memanggil object http

    var hasilResponse = await http.post(url, body: {
      "nim": nim,
      "nama": nama,
      "jk": jk,
      "alamat": alamat,
      "jurusan": jurusan,
    });

    if (hasilResponse.statusCode == 201) {
      _data = (json.decode(hasilResponse.body));

      // untuk terjadinya perubahan di page home_stateful.dart
      notifyListeners();
      print("berhasil");
    } else {
      print("gagal");
      print(hasilResponse.statusCode);
    }
  }

  // method notifikasi snackbar
  handlingStatusCode(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 700),
      ),
    );
  }
}

//snackbar jika sudah data diinputkan dan dikirimkan ke databse
//   berhasilPostData(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text("Data berhasil ditambahkan"),
//       duration: Duration(seconds: 1),
//     ));
// }

// untuk Form data
class InputData {
  late String nim, nama, jk, alamat, jurusan;
}

// untuk menampung id update data saja methodnya seperti post namun hanya nampung id saja
class IdSingleUser {
  // tidak bisa dirubah;
  static late String id, nim, nama, jk, alamat, jurusan;
}
