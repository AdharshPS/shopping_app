# Shopping App (Flutter)

A simple **Shopping Application** built using **Flutter** following **Clean Architecture principles**.  
The app supports **product listing**, **cart management with quantity control**, and **local data storage using Hive**.

## Features
- Login using google authentication
- Product listing and product detail
- Product categorizing
- Add products to cart
- Increment and decrement functionality for each item in cart
- Prevent duplicate cart entry
- Total amount of added items in cart
- Clearing the cart items
- Logging out from the app

### 1️⃣ Clone the repository
```bash
git clone https://github.com/AdharshPS/shopping_app.git

git pub get

flutter pub run build_runner build --delete-conflicting-outputs

flutter run
```