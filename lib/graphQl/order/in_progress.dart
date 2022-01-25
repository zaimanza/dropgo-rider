const String inProgress = r"""
mutation InProgress {
  inProgress {
    _id
    dateCreated
    dateAccepted
    dateFinish
    items {
      _id
      itemState
      trackCode
      itemImg
      totalPrice
      itemInstruction
      updateAt
      receiver {
        _id
        name
        pNumber
      }
      address {
        _id
        latLng
        state
        city
        country
        fullAddr
        postcode
        unitFloor
      }
    }
    address {
      _id
      latLng
      state
      city
      country
      fullAddr
      postcode
      unitFloor
    }
    vendor {
      _id
      name
      email
      pNumber
      createAt
      updateAt
    }
    rider {
      _id
      name
      email
      pNumber
      liveLatLng
      profileImg
      vehicle {
        _id
        plateNum
        type
        vehicleModel
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
