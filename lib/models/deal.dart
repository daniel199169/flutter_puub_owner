class Deal {
  String id;
  String imageUrl;
  String label;
  String description;
  String parentID;
  DateTime startTime;
  DateTime endTime;
  DateTime creationTime;
  Map<String, bool> pubAmenity;
  String dealImageURL;
  Deal({
    this.id,
    this.imageUrl,
    this.label,
    this.description,
    this.parentID,
    this.startTime,
    this.endTime,
    this.creationTime,
    this.pubAmenity,
    this.dealImageURL,
  });

  factory Deal.fromMap(Map data) {
    data = data ?? {};
    return Deal(
      id: data['id'],
      imageUrl: data['imageURL'],
      description: data['description'],
      label: data['label'],
      parentID: data['parentDealID'],
      startTime: data['startTime'].toDate(),
      endTime: data['endTime'].toDate(),
      creationTime: data['creationTime'].toDate(),
      pubAmenity: data['pubAmenity'] ?? new Map(),
      dealImageURL: data['dealImageURL'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonDeal = new Map<String, dynamic>();
    jsonDeal['id'] = this.id.trim();
    jsonDeal['imageUrl'] = this.imageUrl.trim();
    jsonDeal['label'] = this.label.trim();
    jsonDeal['description'] = this.description.trim();
    jsonDeal['parentDealID'] = this.parentID.trim();
    jsonDeal['startTime'] = this.startTime;
    jsonDeal['endTime'] = this.endTime;
    jsonDeal['creationTime'] = this.creationTime;
    jsonDeal['pubAmenity'] = this.pubAmenity;
    jsonDeal['dealImageURL'] = this.dealImageURL.trim();
    return jsonDeal;
  }
}
