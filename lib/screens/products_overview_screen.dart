import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/enums/filterd_options.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _showOnlyFavoritesData = false;
  var _isInit = true;
  var _isLoadIng = false;

  @override
  void initState() {
    /// this wont work because we can't use any context in initstate
    // Provider.of<Products>(context).fetchAndSetProduct();

    /// this will work but it's a hack

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProduct();
    // });

    super.initState();
  }

  /// this method will run after the widget fully initialized
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoadIng = true;
      });
      _isLoadIng = true;
      Provider.of<Products>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoadIng = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavoritesData = true;
                } else {
                  _showOnlyFavoritesData = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Only Favorites',
                ),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text(
                  'Show All',
                ),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
              builder: (_, cart, child) => Badge(
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                    ),
                    value: cart.itemCount.toString(),
                  )),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoadIng
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ProductsGrid(_showOnlyFavoritesData),
    );
  }
}
