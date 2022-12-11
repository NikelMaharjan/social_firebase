


class AuthExceptionHandler {

  static String handleException(e) {

    print(e.code);
    switch (e.code) {
      case "user-not-found":
        return "No account registered for that email";

      case "wrong-password":
        return "Your password is wrong.";

      case "ERROR_USER_NOT_FOUND":
        return "User with this email doesn't exist.";

      case "ERROR_USER_DISABLED":
        return  "User with this email has been disabled.";

      case "ERROR_TOO_MANY_REQUESTS":
        return "Too many requests. Try again later.";


      case "network-request-failed":
        return "no internet connection";

      case "email-already-in-use":
        return    "The email has already been registered. Please use another email";

      default:
        return   "An undefined Error happened.";
    }

  }



}