// login exceptions

class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

// Register exceptions

class WeakPasswordException implements Exception {}

class EmailAlreadyInUse implements Exception {}

class InvalidEmailException implements Exception {}

// Generic exception 

class GenericException implements Exception {}

class UserNotLoggedIn implements Exception {}