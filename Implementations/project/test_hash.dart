import 'package:bcrypt/bcrypt.dart';

void main() {
  final hash = r'$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.';
  final passwordsToTest = ['password', 'password123', 'admin', '123456', 'dr_kovac'];
  
  for (final pwd in passwordsToTest) {
    if (BCrypt.checkpw(pwd, hash)) {
      print('Match found! Password is: $pwd');
      return;
    }
  }
  print('No match found.');
}
