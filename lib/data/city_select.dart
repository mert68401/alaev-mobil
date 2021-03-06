List<Map<String, String>> cities = [
  {'value': 'Hepsi', 'title': 'Hepsi'},
  {'value': 'ADANA', 'title': 'ADANA'},
  {'value': 'ADIYAMAN', 'title': 'ADIYAMAN'},
  {'value': 'AFYONKARAHİSAR', 'title': 'AFYONKARAHİSAR'},
  {'value': 'AĞRI', 'title': 'AĞRI'},
  {'value': 'AMASYA', 'title': 'AMASYA'},
  {'value': 'ANKARA', 'title': 'ANKARA'},
  {'value': 'ANTALYA', 'title': 'ANTALYA'},
  {'value': 'ARTVİN', 'title': 'ARTVİN'},
  {'value': 'AYDIN', 'title': 'AYDIN'},
  {'value': 'BALIKESİR', 'title': 'BALIKESİR'},
  {'value': 'BİLECİK', 'title': 'BİLECİK'},
  {'value': 'BİNGÖL', 'title': 'BİNGÖL'},
  {'value': 'BİTLİS', 'title': 'BİTLİS'},
  {'value': 'BOLU', 'title': 'BOLU'},
  {'value': 'BURDUR', 'title': 'BURDUR'},
  {'value': 'BURSA', 'title': 'BURSA'},
  {'value': 'ÇANAKKALE', 'title': 'ÇANAKKALE'},
  {'value': 'ÇANKIRI', 'title': 'ÇANKIRI'},
  {'value': 'ÇORUM', 'title': 'ÇORUM'},
  {'value': 'DENİZLİ', 'title': 'DENİZLİ'},
  {'value': 'DİYARBAKIR', 'title': 'DİYARBAKIR'},
  {'value': 'EDİRNE', 'title': 'EDİRNE'},
  {'value': 'ELAZIĞ', 'title': 'ELAZIĞ'},
  {'value': 'ERZİNCAN', 'title': 'ERZİNCAN'},
  {'value': 'ERZURUM', 'title': 'ERZURUM'},
  {'value': 'ESKİŞEHİR', 'title': 'ESKİŞEHİR'},
  {'value': 'GAZİANTEP', 'title': 'GAZİANTEP'},
  {'value': 'GİRESUN', 'title': 'GİRESUN'},
  {'value': 'GÜMÜŞHANE', 'title': 'GÜMÜŞHANE'},
  {'value': 'HAKKARİ', 'title': 'HAKKARİ'},
  {'value': 'HATAY', 'title': 'HATAY'},
  {'value': 'ISPARTA', 'title': 'ISPARTA'},
  {'value': 'MERSİN', 'title': 'MERSİN'},
  {'value': 'İSTANBUL', 'title': 'İSTANBUL'},
  {'value': 'İZMİR', 'title': 'İZMİR'},
  {'value': 'KARS', 'title': 'KARS'},
  {'value': 'KASTAMONU', 'title': 'KASTAMONU'},
  {'value': 'KAYSERİ', 'title': 'KAYSERİ'},
  {'value': 'KIRKLARELİ', 'title': 'KIRKLARELİ'},
  {'value': 'KIRŞEHİR', 'title': 'KIRŞEHİR'},
  {'value': 'KOCAELİ', 'title': 'KOCAELİ'},
  {'value': 'KONYA', 'title': 'KONYA'},
  {'value': 'KÜTAHYA', 'title': 'KÜTAHYA'},
  {'value': 'MALATYA', 'title': 'MALATYA'},
  {'value': 'MANİSA', 'title': 'MANİSA'},
  {'value': 'KAHRAMANMARAŞ', 'title': 'KAHRAMANMARAŞ'},
  {'value': 'MARDİN', 'title': 'MARDİN'},
  {'value': 'MUĞLA', 'title': 'MUĞLA'},
  {'value': 'MUŞ', 'title': 'MUŞ'},
  {'value': 'NEVŞEHİR', 'title': 'NEVŞEHİR'},
  {'value': 'NİĞDE', 'title': 'NİĞDE'},
  {'value': 'ORDU', 'title': 'ORDU'},
  {'value': 'RİZE', 'title': 'RİZE'},
  {'value': 'SAKARYA', 'title': 'SAKARYA'},
  {'value': 'SAMSUN', 'title': 'SAMSUN'},
  {'value': 'SİİRT', 'title': 'SİİRT'},
  {'value': 'SİNOP', 'title': 'SİNOP'},
  {'value': 'SİVAS', 'title': 'SİVAS'},
  {'value': 'TEKİRDAĞ', 'title': 'TEKİRDAĞ'},
  {'value': 'TOKAT', 'title': 'TOKAT'},
  {'value': 'TRABZON', 'title': 'TRABZON'},
  {'value': 'TUNCELİ', 'title': 'TUNCELİ'},
  {'value': 'ŞANLIURFA', 'title': 'ŞANLIURFA'},
  {'value': 'UŞAK', 'title': 'UŞAK'},
  {'value': 'VAN', 'title': 'VAN'},
  {'value': 'YOZGAT', 'title': 'YOZGAT'},
  {'value': 'ZONGULDAK', 'title': 'ZONGULDAK'},
  {'value': 'AKSARAY', 'title': 'AKSARAY'},
  {'value': 'BAYBURT', 'title': 'BAYBURT'},
  {'value': 'KARAMAN', 'title': 'KARAMAN'},
  {'value': 'KIRIKKALE', 'title': 'KIRIKKALE'},
  {'value': 'BATMAN', 'title': 'BATMAN'},
  {'value': 'ŞIRNAK', 'title': 'ŞIRNAK'},
  {'value': 'BARTIN', 'title': 'BARTIN'},
  {'value': 'ARDAHAN', 'title': 'ARDAHAN'},
  {'value': 'IĞDIR', 'title': 'IĞDIR'},
  {'value': 'YALOVA', 'title': 'YALOVA'},
  {'value': 'KARABüK', 'title': 'KARABüK'},
  {'value': 'KİLİS', 'title': 'KİLİS'},
  {'value': 'OSMANİYE', 'title': 'OSMANİYE'},
  {'value': 'DÜZCE', 'title': 'DÜZCE'},
];

List<Map<String, String>> citiesWithoutAll = [
  {'value': 'ADANA', 'title': 'ADANA'},
  {'value': 'ADIYAMAN', 'title': 'ADIYAMAN'},
  {'value': 'AFYONKARAHİSAR', 'title': 'AFYONKARAHİSAR'},
  {'value': 'AĞRI', 'title': 'AĞRI'},
  {'value': 'AMASYA', 'title': 'AMASYA'},
  {'value': 'ANKARA', 'title': 'ANKARA'},
  {'value': 'ANTALYA', 'title': 'ANTALYA'},
  {'value': 'ARTVİN', 'title': 'ARTVİN'},
  {'value': 'AYDIN', 'title': 'AYDIN'},
  {'value': 'BALIKESİR', 'title': 'BALIKESİR'},
  {'value': 'BİLECİK', 'title': 'BİLECİK'},
  {'value': 'BİNGÖL', 'title': 'BİNGÖL'},
  {'value': 'BİTLİS', 'title': 'BİTLİS'},
  {'value': 'BOLU', 'title': 'BOLU'},
  {'value': 'BURDUR', 'title': 'BURDUR'},
  {'value': 'BURSA', 'title': 'BURSA'},
  {'value': 'ÇANAKKALE', 'title': 'ÇANAKKALE'},
  {'value': 'ÇANKIRI', 'title': 'ÇANKIRI'},
  {'value': 'ÇORUM', 'title': 'ÇORUM'},
  {'value': 'DENİZLİ', 'title': 'DENİZLİ'},
  {'value': 'DİYARBAKIR', 'title': 'DİYARBAKIR'},
  {'value': 'EDİRNE', 'title': 'EDİRNE'},
  {'value': 'ELAZIĞ', 'title': 'ELAZIĞ'},
  {'value': 'ERZİNCAN', 'title': 'ERZİNCAN'},
  {'value': 'ERZURUM', 'title': 'ERZURUM'},
  {'value': 'ESKİŞEHİR', 'title': 'ESKİŞEHİR'},
  {'value': 'GAZİANTEP', 'title': 'GAZİANTEP'},
  {'value': 'GİRESUN', 'title': 'GİRESUN'},
  {'value': 'GÜMÜŞHANE', 'title': 'GÜMÜŞHANE'},
  {'value': 'HAKKARİ', 'title': 'HAKKARİ'},
  {'value': 'HATAY', 'title': 'HATAY'},
  {'value': 'ISPARTA', 'title': 'ISPARTA'},
  {'value': 'MERSİN', 'title': 'MERSİN'},
  {'value': 'İSTANBUL', 'title': 'İSTANBUL'},
  {'value': 'İZMİR', 'title': 'İZMİR'},
  {'value': 'KARS', 'title': 'KARS'},
  {'value': 'KASTAMONU', 'title': 'KASTAMONU'},
  {'value': 'KAYSERİ', 'title': 'KAYSERİ'},
  {'value': 'KIRKLARELİ', 'title': 'KIRKLARELİ'},
  {'value': 'KIRŞEHİR', 'title': 'KIRŞEHİR'},
  {'value': 'KOCAELİ', 'title': 'KOCAELİ'},
  {'value': 'KONYA', 'title': 'KONYA'},
  {'value': 'KÜTAHYA', 'title': 'KÜTAHYA'},
  {'value': 'MALATYA', 'title': 'MALATYA'},
  {'value': 'MANİSA', 'title': 'MANİSA'},
  {'value': 'KAHRAMANMARAŞ', 'title': 'KAHRAMANMARAŞ'},
  {'value': 'MARDİN', 'title': 'MARDİN'},
  {'value': 'MUĞLA', 'title': 'MUĞLA'},
  {'value': 'MUŞ', 'title': 'MUŞ'},
  {'value': 'NEVŞEHİR', 'title': 'NEVŞEHİR'},
  {'value': 'NİĞDE', 'title': 'NİĞDE'},
  {'value': 'ORDU', 'title': 'ORDU'},
  {'value': 'RİZE', 'title': 'RİZE'},
  {'value': 'SAKARYA', 'title': 'SAKARYA'},
  {'value': 'SAMSUN', 'title': 'SAMSUN'},
  {'value': 'SİİRT', 'title': 'SİİRT'},
  {'value': 'SİNOP', 'title': 'SİNOP'},
  {'value': 'SİVAS', 'title': 'SİVAS'},
  {'value': 'TEKİRDAĞ', 'title': 'TEKİRDAĞ'},
  {'value': 'TOKAT', 'title': 'TOKAT'},
  {'value': 'TRABZON', 'title': 'TRABZON'},
  {'value': 'TUNCELİ', 'title': 'TUNCELİ'},
  {'value': 'ŞANLIURFA', 'title': 'ŞANLIURFA'},
  {'value': 'UŞAK', 'title': 'UŞAK'},
  {'value': 'VAN', 'title': 'VAN'},
  {'value': 'YOZGAT', 'title': 'YOZGAT'},
  {'value': 'ZONGULDAK', 'title': 'ZONGULDAK'},
  {'value': 'AKSARAY', 'title': 'AKSARAY'},
  {'value': 'BAYBURT', 'title': 'BAYBURT'},
  {'value': 'KARAMAN', 'title': 'KARAMAN'},
  {'value': 'KIRIKKALE', 'title': 'KIRIKKALE'},
  {'value': 'BATMAN', 'title': 'BATMAN'},
  {'value': 'ŞIRNAK', 'title': 'ŞIRNAK'},
  {'value': 'BARTIN', 'title': 'BARTIN'},
  {'value': 'ARDAHAN', 'title': 'ARDAHAN'},
  {'value': 'IĞDIR', 'title': 'IĞDIR'},
  {'value': 'YALOVA', 'title': 'YALOVA'},
  {'value': 'KARABüK', 'title': 'KARABüK'},
  {'value': 'KİLİS', 'title': 'KİLİS'},
  {'value': 'OSMANİYE', 'title': 'OSMANİYE'},
  {'value': 'DÜZCE', 'title': 'DÜZCE'},
];