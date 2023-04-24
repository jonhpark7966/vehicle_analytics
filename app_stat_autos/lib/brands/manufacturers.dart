enum Manufactureres {
  hyundai,
  kia,
  genesis,
  bmw,
  benz,
  audi,
  ford,
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
      case "ford":
        return Manufactureres.ford;
    }

    return Manufactureres.unknown;
  }

}

