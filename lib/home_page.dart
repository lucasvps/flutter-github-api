import 'package:flutter/material.dart';
import 'package:github_repo/models/user_model.dart';
import 'package:github_repo/repositories/user_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserRepository repository = UserRepository();
  String search = '';

  void makeSearch(String value) {
    setState(() {
      search = value;
    });
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('GitHub Api'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      labelText: 'Pesquisar',
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            controller.text = "";
                          });
                        },
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                      )),
                  onChanged: (value) => makeSearch(controller.text),
                ),
              ),
              FutureBuilder(
                future: repository.usersList(controller.text),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return _loading();
                      break;
                    case ConnectionState.none:
                      return _error("Nada a ser mostrado!");
                      break;
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return _error(snapshot.error.toString());
                      }
                      if (!snapshot.hasData) {
                        return _error("No data");
                      } else {
                        return list(
                          snapshot.data,
                        );
                      }
                      break;
                  }
                },
              )
            ],
          ),
        ));
  }

  Widget _error(String e) {
    return Container(
      child: Center(
        child: Text(e),
      ),
    );
  }

  Widget _loading() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget list(List<User> users) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          child: Card(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: users.length == null ? 1 : users.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.grey[200],
                      child: ListTile(
                        leading: Container(
                          width: 39,
                          height: 39,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      NetworkImage(users[index].avatarUrl))),
                        ),
                        title: Text("Usuário: ${users[index].login}"),
                        //subtitle: Text(users[index].),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
