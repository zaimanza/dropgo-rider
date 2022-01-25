const String addRider = r"""
mutation AddRider($name: String!, $password: String!, $pNumber: String!, $profileImg: String!, $plateNum: String!, $type: String!, $vehicleModel: String!, $email: String!) {
  addRider(name: $name, password: $password, pNumber: $pNumber, profileImg: $profileImg, plateNum: $plateNum, type: $type, vehicleModel: $vehicleModel, email: $email)
}
""";
