import 'package:example/user.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:pagination_view/pagination_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page;
  PaginationViewType paginationViewType;

  @override
  void initState() {
    page = -1;
    paginationViewType = PaginationViewType.listView;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PaginationView Example'),
        actions: <Widget>[
          (paginationViewType == PaginationViewType.listView)
              ? IconButton(
                  icon: Icon(Icons.grid_on),
                  onPressed: () => setState(
                      () => paginationViewType = PaginationViewType.gridView),
                )
              : IconButton(
                  icon: Icon(Icons.list),
                  onPressed: () => setState(
                      () => paginationViewType = PaginationViewType.listView),
                ),
        ],
      ),
      body: PaginationView<User>(
        preloadedItems: <User>[
          User(faker.person.name(), faker.internet.email()),
          User(faker.person.name(), faker.internet.email()),
        ],
        paginationViewType: paginationViewType,
        itemBuilder: (BuildContext context, User user, int index) =>
            (paginationViewType == PaginationViewType.listView)
                ? ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    leading: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  )
                : GridTile(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(child: Icon(Icons.person)),
                        const SizedBox(height: 8),
                        Text(user.name),
                        const SizedBox(height: 8),
                        Text(user.email),
                      ],
                    ),
                  ),
        pageFetch: pageFetch,
        onError: (dynamic error) => Center(
          child: Text('Some error occured'),
        ),
        onEmpty: Center(
          child: Text('Sorry! This is empty'),
        ),
        bottomLoader: Center(
          child: CircularProgressIndicator(),
        ),
        initialLoader: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<List<User>> pageFetch(int offset, User currentUser) async {
    print(offset);
    print(currentUser);
    page++;
    final Faker faker = Faker();
    final List<User> nextUsersList = List.generate(
      10,
      (int index) => User(
        faker.person.name() + ' - $page$index',
        faker.internet.email(),
      ),
    );
    await Future<List<User>>.delayed(Duration(seconds: 1));

    return page == 7 ? [] : nextUsersList;
  }
}
