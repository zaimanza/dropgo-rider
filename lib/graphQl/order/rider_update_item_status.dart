const String riderUpdateItemStatus = r"""
mutation RiderUpdateItemStatus($orderId: ID!, $itemId: ID!, $itemState: String!) {
  riderUpdateItemStatus(orderId: $orderId, itemId: $itemId, itemState: $itemState)
}
""";
