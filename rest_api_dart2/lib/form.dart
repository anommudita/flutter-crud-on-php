import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_dart/models/http_provider.dart';
// import 'package:rest_api_dart/models/get_provider.dart';

class tampilanForm extends StatefulWidget {
  tampilanForm({Key? key}) : super(key: key);

  @override
  State<tampilanForm> createState() => _tampilanFormState();
}

class _tampilanFormState extends State<tampilanForm> {
  @override
  Widget build(BuildContext context) {
    // membuat file dataProvider
    final dataProvider = Provider.of<HttpProvider>(context, listen: false);

    final _formKey = GlobalKey<FormState>();

    // instasiasi class
    InputData dataValue = InputData();

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Method"),
      ),
      body: Form(
        key: _formKey, // key form like id
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: [
              TextFormField(
                  decoration: InputDecoration(
                    hintText: "masukan nim lengkap anda",
                    labelText: "NIM",
                    // icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'NIM tidak boleh kosong';
                    }
                    dataValue.nim = value.toString();
                    return null;
                  }),
              SizedBox(height: 20),
              TextFormField(
                  decoration: InputDecoration(
                    hintText: "masukan nama lengkap anda",
                    labelText: "Nama Lengkap",
                    // icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    dataValue.nama = value;
                    return null;
                  }),
              SizedBox(height: 20),
              TextFormField(
                  decoration: InputDecoration(
                    hintText: "masukan jenis kelamin anda",
                    labelText: "Jenis Kelamin",
                    // icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Jenis Kelamin tidak boleh kosong';
                    }
                    dataValue.jk = value;
                    return null;
                  }),
              SizedBox(height: 20),
              TextFormField(
                  decoration: InputDecoration(
                    hintText: "masukan alamat anda",
                    labelText: "Alamat",
                    // icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    dataValue.alamat = value;
                    return null;
                  }),
              SizedBox(height: 20),
              TextFormField(
                  decoration: InputDecoration(
                    hintText: "masukan jurusan anda",
                    labelText: "Jurusan",
                    // icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Jurusan tidak boleh kosong';
                    }
                    dataValue.jurusan = value;
                    return null;
                  }),
              SizedBox(height: 30),
              RaisedButton(
                child: Text(
                  "Tambahkan Data",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    dataProvider.connectAPI(
                      dataValue.nim,
                      dataValue.nama,
                      dataValue.jk,
                      dataValue.alamat,
                      dataValue.jurusan,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Data Berhasil Ditambahkan"),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 15),
              RaisedButton(
                child: Text(
                  "Method(GET - DELETE - UPDATE)",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                          create: (context) => HttpProvider(),
                          child: GetData()));
                  Navigator.push(context, route);

                  // relod supaya data terlihat sudah
                  // Navigator.push(context, route);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // get data ListUser
class GetData extends StatelessWidget {
  @override
  late Uri apiUrl = Uri.parse("http://localhost/restapi_server/index.php");
  Future<List<dynamic>> _fecthDataUsers() async {
    var result = await http.get(apiUrl);
    return json.decode(result.body)['data'];
  }

  Widget build(BuildContext context) {
    // memanggil provider untuk delete
    final dataProvider = Provider.of<HttpProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('GET - DELETE - UPDATE'),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: _fecthDataUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => singleUser());
                        Navigator.push(context, route);
                      },
                      child: ListTile(
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: Text("CONFIRM"),
                                              content: Text(
                                                  "Are you sure to delete this data!"),
                                              actions: [
                                                FlatButton(
                                                  onPressed: () {
                                                    print("Klik No");
                                                    // pop = membuat lalu keluar
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("No"),
                                                ),
                                                FlatButton(
                                                  onPressed: () {
                                                    print("Klik Yes");

                                                    dataProvider.deleteData(
                                                      snapshot.data[index]["id"]
                                                          .toString(),
                                                    );
                                                    Route route = MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChangeNotifierProvider(
                                                                create: (context) =>
                                                                    HttpProvider(),
                                                                child:
                                                                    tampilanForm()));
                                                    Navigator.push(
                                                        context, route);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            "Data Berhasil Dihapus"),
                                                      ),
                                                    );
                                                  },
                                                  child: Text("Yes"),
                                                )
                                              ]);
                                        });
                                  }),
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Route route = MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider(
                                                create: (context) =>
                                                    HttpProvider(),
                                                child: UpdateData()));
                                    IdSingleUser.id =
                                        snapshot.data[index]["id"].toString();
                                    IdSingleUser.nim =
                                        snapshot.data[index]["nim"].toString();
                                    IdSingleUser.nama =
                                        snapshot.data[index]["nama"].toString();
                                    IdSingleUser.jk =
                                        snapshot.data[index]["jk"].toString();
                                    IdSingleUser.alamat = snapshot.data[index]
                                            ["alamat"]
                                        .toString();
                                    IdSingleUser.jurusan = snapshot.data[index]
                                            ["jurusan"]
                                        .toString();
                                    Navigator.push(context, route);
                                  }),
                            ],
                          ),
                        ),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              "https://i.pinimg.com/564x/b6/6d/22/b66d22a8b57900e75cbab27192cd58a3.jpg"),
                        ),
                        title: Text(snapshot.data[index]['nama']),
                        subtitle: Text(snapshot.data[index]['alamat']),
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

// Class Update Data
class UpdateData extends StatefulWidget {
  UpdateData({Key? key}) : super(key: key);

  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  @override
  Widget build(BuildContext context) {
    // membuat file dataProvider
    final dataProvider = Provider.of<HttpProvider>(context, listen: false);

    final _formKey = GlobalKey<FormState>();

    // instasiasi class
    InputData dataValue = InputData();

    return Scaffold(
      appBar: AppBar(
        title: Text("Update Method"),
      ),
      body: Form(
        key: _formKey, // key form like id
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: [
              TextFormField(
                  //untuk menimpa data lama
                  initialValue: IdSingleUser.nim,
                  decoration: InputDecoration(
                    hintText: "masukan nim lengkap anda",
                    labelText: "NIM",
                    // icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'NIM tidak boleh kosong';
                    }
                    dataValue.nim = value.toString();
                    return null;
                  }),
              SizedBox(height: 20),
              TextFormField(
                  //untuk menimpa data lama
                  initialValue: IdSingleUser.nama,
                  decoration: InputDecoration(
                    hintText: "masukan nama lengkap anda",
                    labelText: "Nama Lengkap",
                    // icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    dataValue.nama = value;
                    return null;
                  }),
              SizedBox(height: 20),
              TextFormField(
                  //untuk menimpa data lama
                  initialValue: IdSingleUser.jk,
                  decoration: InputDecoration(
                    hintText: "masukan jenis kelamin anda",
                    labelText: "Jenis Kelamin",
                    // icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Jenis Kelamin tidak boleh kosong';
                    }
                    dataValue.jk = value;
                    return null;
                  }),
              SizedBox(height: 20),
              TextFormField(
                  //untuk menimpa data lama
                  initialValue: IdSingleUser.alamat,
                  decoration: InputDecoration(
                    hintText: "masukan alamat anda",
                    labelText: "Alamat",
                    // icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    dataValue.alamat = value;
                    return null;
                  }),
              SizedBox(height: 20),
              TextFormField(
                  //untuk menimpa data lama
                  initialValue: IdSingleUser.jurusan,
                  decoration: InputDecoration(
                    hintText: "masukan jurusan anda",
                    labelText: "Jurusan",
                    // icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Jurusan tidak boleh kosong';
                    }
                    dataValue.jurusan = value;
                    return null;
                  }),
              SizedBox(height: 30),
              RaisedButton(
                child: Text(
                  "Update Data",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: Text("CONFIRM"),
                            content: Text("Are you sure to edit this data!"),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  print("Klik No");
                                  // pop = membuat lalu keluar
                                  Navigator.of(context).pop();
                                },
                                child: Text("No"),
                              ),
                              FlatButton(
                                onPressed: () {
                                  print("Klik Yes");
                                  if (_formKey.currentState!.validate()) {
                                    dataProvider.updateData(
                                      IdSingleUser.id,
                                      dataValue.nim,
                                      dataValue.nama,
                                      dataValue.jk,
                                      dataValue.alamat,
                                      dataValue.jurusan,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Data Berhasil Update!"),
                                      ),
                                    );

                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text("Yes"),
                              )
                            ]);
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dalam Perkembangan! - Anom Mudita Ganteng
class singleUser extends StatefulWidget {
  singleUser({Key? key}) : super(key: key);

  @override
  State<singleUser> createState() => _singleUserState();
}

class _singleUserState extends State<singleUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GET - Maintenance"),
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: [
              FittedBox(child: Text("ID : ", style: TextStyle(fontSize: 20))),
              FittedBox(
                child: Consumer<HttpProvider>(
                  builder: (context, value, child) => Text(
                    (value.data["id"] == null)
                        ? "Belum ada data"
                        : value.data["id"],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 5),
              FittedBox(child: Text("NIM : ", style: TextStyle(fontSize: 20))),
              FittedBox(
                child: Consumer<HttpProvider>(
                  builder: (context, value, child) => Text(
                    (value.data["nim"] == null)
                        ? "Belum ada data"
                        : value.data["id"],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 5),
              FittedBox(child: Text("Nama : ", style: TextStyle(fontSize: 20))),
              FittedBox(
                child: Consumer<HttpProvider>(
                  builder: (context, value, child) => Text(
                    (value.data["nama"] == null)
                        ? "Belum ada data"
                        : value.data["nama"],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 5),
              FittedBox(
                  child:
                      Text("Jenis Kelamin : ", style: TextStyle(fontSize: 20))),
              FittedBox(
                child: Consumer<HttpProvider>(
                  builder: (context, value, child) => Text(
                    (value.data["jk"] == null)
                        ? "Belum ada data"
                        : value.data["jk"],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 5),
              FittedBox(
                  child: Text("Alamat : ", style: TextStyle(fontSize: 20))),
              FittedBox(
                child: Consumer<HttpProvider>(
                  builder: (context, value, child) => Text(
                    (value.data["alamat"] == null)
                        ? "Belum ada data"
                        : value.data["alamat"],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              FittedBox(
                  child: Text("Jurusan : ", style: TextStyle(fontSize: 20))),
              FittedBox(
                child: Consumer<HttpProvider>(
                  builder: (context, value, child) => Text(
                    (value.data["jurusan"] == null)
                        ? "Belum ada data"
                        : value.data["jurusan"],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(height: 50),
              OutlinedButton(
                onPressed: () {
                  // String value = "1";
                  // HttpStateful.connectAPI(value.toString()).then(
                  //   (value) {
                  //     setState(() {
                  //       dataResponse = value;
                  //     });
                  //   },
                  // );
                },
                child: Text(
                  "GET DATA 1",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(height: 25),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
