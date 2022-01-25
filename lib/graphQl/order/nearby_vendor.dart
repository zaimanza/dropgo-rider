const String nearbyVendor = r"""
query NearbyVendor($liveLatLng: String!) {
  nearbyVendor(liveLatLng: $liveLatLng) {
    _id
    dateAccepted
    dateFinish
    dateCreated
    items {
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
      liveLatLng
      pNumber
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
