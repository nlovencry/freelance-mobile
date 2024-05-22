class PaketFilterModel {
  bool reguler;
  bool promo;
  String? kotaKeberangkatan;
  int? bulanKeberangkatan;
  PaketFilterModel(
      {this.reguler = false,
      this.promo = false,
      this.kotaKeberangkatan,
      this.bulanKeberangkatan});
}
