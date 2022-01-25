const String riderLogIn = r"""
mutation RiderLogIn($email: String!, $fcmToken: String!, $password: String!) {
  riderLogIn(email: $email, fcmToken: $fcmToken, password: $password) {
    _id
    name
    email
    pNumber
    createAt
    updateAt
    isWork
    profileImg
    wallet {
      _id
    }
    vehicle {
      _id
      plateNum
      type
      vehicleModel
    }
    accessToken
  }
}
""";
