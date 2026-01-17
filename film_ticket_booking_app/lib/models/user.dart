// Mimic a database table for users
List<User> usersTable = [
  User(email: 'test@gmail.com', password: '123456', name: 'Test User', phone: '0123456789'),
];

class User {
  String name;
  String email;
  String password;
  String phone;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });
}

// Database-like functions (simulate queries)
class UserDB {
  // Insert new user
  static Future<void> insertUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 200)); // simulate db delay
    usersTable.add(user);
  }

  // Get user by email & password
  static Future<User?> getUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 200)); // simulate db delay
    try {
      return usersTable.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // Check if email already exists
  static Future<bool> emailExists(String email) async {
    await Future.delayed(const Duration(milliseconds: 100)); // simulate db delay
    return usersTable.any((user) => user.email == email);
  }
}