const String startWork = r"""
mutation StartWork($liveLatLng: String) {
  startWork(liveLatLng: $liveLatLng) {
    _id
    dateCreated
    dateAccepted
    dateFinish
    items {
      address {
        postcode
        fullAddr
        unitFloor
        country
        city
        state
        latLng
        _id
      }
      receiver {
        pNumber
        name
        _id
      }
      updateAt
      itemInstruction
      totalPrice
      itemImg
      trackCode
      itemState
      _id
    }
    address {
      unitFloor
      postcode
      fullAddr
      country
      city
      state
      latLng
      _id
    }
    vendor {
      updateAt
      createAt
      pNumber
      email
      name
      _id
    }
    rider {
      _id
      name
      email
      pNumber
      liveLatLng
      profileImg
      vehicle {
        vehicleModel
        type
        plateNum
        _id
      }
      createAt
      updateAt
      isWork
      wallet {
        _id
      }
    }
  }
}
""";
