import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/src/app/pages/tabs/orders_tab/orders_tab.dart';
import 'package:gerenciamento_loja/src/app/pages/tabs/users_tab/users_tab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.pinkAccent,
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.white54))),
        child: BottomNavigationBar(
            currentIndex: _page,
            onTap: (p) {
              _pageController.animateToPage(p,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text("Clientes")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), title: Text("Pedidos")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), title: Text("Produtos"))
            ]),
      ),
      body: Scaffold(
        backgroundColor: Colors.grey[850],
        body: SafeArea(
          child: PageView(
            onPageChanged: (p) {
              setState(() {
                _page = p;
              });
            },
            controller: _pageController,
            children: <Widget>[
              UsersTab(),
              OrdersTab(),
              Container(color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
