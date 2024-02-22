import 'dart:html';
import 'dart:convert';

main() async {
  var osoite = 'kysymykset.json';
  var sisalto = await HttpRequest.getString(osoite);
  var sanakirja = jsonDecode(sisalto);

  var kysymykset = sanakirja['kysymykset'];
  querySelector('#vastaukset')?.children.clear();
  querySelector('#kysymys')?.text = "Klikkaa nappia aloittaaksesi.";
  aloita(kysymykset);
}

aloita(kysymykset) {
  querySelector('#seuraava')?.onClick.listen((e) {
    kysymykset.shuffle();
    asetaKysymys(kysymykset[0], kysymykset);
  });
}

asetaKysymys(kysymys, kysymykset) {
  asetaKysymysteksti(kysymys['teksti']);
  asetaVastausvaihtoehdot(kysymys['vaihtoehdot'], kysymykset);
}

asetaKysymysteksti(teksti) {
  querySelector('#kysymys')?.text = teksti;
}

asetaVastausvaihtoehdot(vaihtoehdot, kysymykset) {
  querySelector('#vastaukset')?.children.clear();

  for (var i = 0; i < vaihtoehdot.length; i++) {
    lisaaVastausvaihtoehto(vaihtoehdot[i], kysymykset);
  }
}

lisaaVastausvaihtoehto(vaihtoehto, kysymykset) {
  var elementti = Element.div();
  elementti.className = 'vaihtoehto';
  elementti.text = vaihtoehto['teksti'];
  var oikein = int.parse(querySelector('#piste')?.text as String);
  var pisteet = int.parse(querySelector('#paste')?.text as String);
  elementti.onClick.listen((e) async {
    if (vaihtoehto['oikein']) {
      elementti.text = 'oikein!';
      elementti.style.backgroundColor = 'green';
      oikein++;
      pisteet++;
      querySelector('#piste')?.text = oikein.toString();
      querySelector('#paste')?.text = pisteet.toString();
      await Future.delayed(Duration(seconds: 2));
      kysymykset.shuffle();
      asetaKysymys(kysymykset[0], kysymykset);
    } else {
      elementti.text = 'väärin!';
      elementti.style.backgroundColor = 'red';
      pisteet++;
      querySelector('#paste')?.text = pisteet.toString();
      await Future.delayed(Duration(seconds: 2));
      kysymykset.shuffle();
      asetaKysymys(kysymykset[0], kysymykset);
    }
  });

  querySelector('#vastaukset')?.children.add(elementti);
}
