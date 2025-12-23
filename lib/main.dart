import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/features/auth/data/datasources/google_auth_ds.dart';
import 'package:shopping_app/features/auth/data/datasources/local_auth_ds.dart';
import 'package:shopping_app/features/auth/data/model/auth_user_model.dart';
import 'package:shopping_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:shopping_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:shopping_app/features/auth/presentation/screens/login_screen.dart';
import 'package:shopping_app/features/cart/data/datasources/cart_ds.dart';
import 'package:shopping_app/features/cart/data/models/cart_model.dart';
import 'package:shopping_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:shopping_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:shopping_app/features/dashboard/presentation/provider/nav_provider.dart';
import 'package:shopping_app/features/dashboard/presentation/screens/bottom_navigation_screen.dart';
import 'package:shopping_app/features/products/data/datasources/product_listing_ds.dart';
import 'package:shopping_app/features/products/data/models/products_model.dart';
import 'package:shopping_app/features/products/data/repositories/products_repository_impl.dart';
import 'package:shopping_app/features/products/presentation/provider/products_list_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(CartModelAdapter());
  Hive.registerAdapter(ProductsModelAdapter());
  Hive.registerAdapter(ProductsModelRatingAdapter());
  Hive.registerAdapter(AuthUserModelAdapter());

  final cartBox = await Hive.openBox<CartModel>('cartBox');
  final userBox = await Hive.openBox<AuthUserModel>('userBox');

  // Product DI
  final productDs = ProductListingDs();
  final productsRepo = ProductsRepositoryImpl(productDs);

  // Cart DI
  final cartDs = CartDs(cartBox);
  final cartRepo = CartRepositoryImpl(cartDs);

  // Cart DI
  final googleAuthDs = GoogleAuthDs();
  final localAuthDs = LocalAuthDs(userBox);
  final authRepo = AuthRepoImpl(
    googleAuthDs: googleAuthDs,
    localAuthDs: localAuthDs,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductsListProvider(productsRepo),
        ),
        ChangeNotifierProvider(create: (context) => CartProvider(cartRepo)),
        ChangeNotifierProvider(create: (context) => NavProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider(authRepo)),
      ],
      child: MainScreen(),
    ),
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<AuthProvider>().getUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
      ),
      home: context.watch<AuthProvider>().loginedUser != null
          ? BottomNavigationScreen()
          : LoginScreen(),
    );
  }
}
