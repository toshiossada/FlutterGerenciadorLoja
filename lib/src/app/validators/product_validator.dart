class ProductValidator {

  String validateImages(List images){
    if(images.isEmpty) return "Adicione imagens do produto";
    return null;
  }

  String validateTitle(String text){
    if(text.isEmpty) return "Preencha o título do produto";
    return null;
  }

  String validateDescription(String text){
    if(text.isEmpty) return "Preencha a descrição do produto";
    return null;
  }

  String validatePrice(String text){
    double price = double.tryParse(text);
    if(price != null){
      if(!text.contains(".") || text.split(".")[1].length != 2)
        return "Utilize 2 casas decimais";
    } else {
      return "Preço inválido";
    }
    return null;
  }

}