import 'dart:math';

int generateOTP() {
  bool isSecure = false;
  int otp = 9873;
  while (isSecure == false) {
    otp = 1000 + Random().nextInt(9999 - 1000);

    List otpSplitted = otp.toString().split('');
    bool duplicateFound = false;

    for (var i = 0; i < otpSplitted.length; i++) {
      for (var j = 0; j < otpSplitted.length; j++) {
        if (otpSplitted[i] == otpSplitted[j] && i != j) {
          duplicateFound = true;
          break;
        }
      }
    }

    isSecure = duplicateFound ? false : true;
  }
  return otp;
}
