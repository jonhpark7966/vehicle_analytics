enum Manufactureres {
  hyundai,
  kia,
  genesis,
  bmw,
  benz,
  audi,
  unknown;

  static Manufactureres fromString(String src){
    String lower = src.toLowerCase();
    switch(lower){
      case "hyundai":
       return Manufactureres.hyundai;
      case "kia":
        return Manufactureres.kia;
      case "genesis":
        return Manufactureres.genesis;
      case "bmw":
        return Manufactureres.bmw;
      case "benz":
        return Manufactureres.benz;
      case "audi":
        return Manufactureres.audi;
    }

    return Manufactureres.unknown;
  }

}

