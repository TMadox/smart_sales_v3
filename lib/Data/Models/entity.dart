class Entity {
  final int id;
  final int code;
  final String name;
  final int accId;
  final int priceId;
  final int employAccId;
  final String taxFileNo;
  final String taxRecordNo;
  final double maxCredit;
  final dynamic payByCash;
  final double curBalance;
  Entity({
    required this.id,
    required this.code,
    required this.name,
    required this.accId,
    required this.priceId,
    required this.employAccId,
    required this.taxFileNo,
    required this.taxRecordNo,
    required this.maxCredit,
    required this.payByCash,
    required this.curBalance,
  });
}
