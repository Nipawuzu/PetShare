abstract class MockUser {
  MockUser(this.login, this.password);

  String login;
  String password;
}

class MockAdmin extends MockUser {
  MockAdmin() : super("admin@test.pl", "Test1234");
}

class MockAdopter extends MockUser {
  MockAdopter() : super("test-adopter@testing.pl", "Testing123");
}

class MockShelter extends MockUser {
  MockShelter() : super("test@test.pl", "Test1234");
}
