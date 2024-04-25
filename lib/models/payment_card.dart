// modeling payment card
class PaymentCard {
  PaymentCard({
    required this.cardHolder,
    required this.cardNo,
    required this.cvv,
    required this.expYear,
    required this.expMonth,
    required this.title,
  });

  late final String cardHolder;
  late final String cardNo;
  late final String cvv;
  late final int expYear;
  late final int expMonth;
  late final String title;

  PaymentCard.fromJson(Map<String, dynamic> json) {
    cardHolder = json['cardHolder'];
    cardNo = json['cardNo'];
    cvv = json['cvv2'];
    expYear = json['expYear'];
    expMonth = json['expMonth'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['cardHolder'] = cardHolder;
    data['cardNo'] = cardNo;
    data['cvv'] = cvv;
    data['expYear'] = expYear;
    data['expMonth'] = expMonth;
    data['title'] = title;
    return data;
  }
}
