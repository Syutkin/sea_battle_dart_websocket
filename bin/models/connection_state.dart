abstract class ConnectionState {}

class Connecting extends ConnectionState {
  @override
  String toString() {
    return 'Подключение';
  }
}

class EnteringName extends Connecting {
  @override
  String toString() {
    return 'Вводит имя';
  }
}

class Authorizing extends Connecting {
  @override
  String toString() {
    return 'Авторизация';
  }
}

class Registering extends Connecting {
  @override
  String toString() {
    return 'Заводит аккаунт';
  }
}

class SettingPassword extends Connecting {
  @override
  String toString() {
    return 'Устанавливает пароль';
  }
}

class RepeatingPassword extends Connecting {
  @override
  String toString() {
    return 'Подтверждение пароля';
  }
}

class Authorized extends ConnectionState {
  @override
  String toString() {
    return 'Авторизирован';
  }
}