const String updateRider = r"""
mutation UpdateRider($profileImg: String, $pNumber: String, $password: String, $email: String, $name: String) {
  updateRider(profileImg: $profileImg, pNumber: $pNumber, password: $password, email: $email, name: $name)
}
""";
