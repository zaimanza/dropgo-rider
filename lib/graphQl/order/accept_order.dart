const String acceptOrder = r"""
mutation AcceptOrder($orderId: ID!) {
  acceptOrder(orderId: $orderId)
}
""";
