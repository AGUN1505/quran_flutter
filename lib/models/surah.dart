// Model data untuk merepresentasikan informasi singkat sebuah Surat
class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final String audioUrl;

  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioUrl,
  });

  // Membuat instance Surah dari objek JSON API
  factory Surah.fromJson(Map<String, dynamic> json) {
    // Get first audio url or fallback
    Map<String, dynamic> audioMap = json['audioFull'] ?? {};
    String audio = audioMap.values.isNotEmpty ? audioMap.values.first : '';

    return Surah(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
      tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      deskripsi: json['deskripsi'] ?? '',
      audioUrl: audio,
    );
  }
}

// Model data untuk merepresentasikan detail satu Ayat Al-Quran
class Ayat {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final String audioUrl;

  Ayat({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audioUrl,
  });

  // Membuat instance Ayat dari objek JSON API
  factory Ayat.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> audioMap = json['audio'] ?? {};
    String audio = audioMap.values.isNotEmpty ? audioMap.values.first : '';

    return Ayat(
      nomorAyat: json['nomorAyat'],
      teksArab: json['teksArab'],
      teksLatin: json['teksLatin'],
      teksIndonesia: json['teksIndonesia'],
      audioUrl: audio,
    );
  }
}

// Model data untuk merepresentasikan detail lengkap sebuah Surat beserta daftar ayatnya
class SurahDetail {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final List<Ayat> ayat;

  SurahDetail({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.ayat,
  });

  // Membuat instance SurahDetail dari objek JSON API
  factory SurahDetail.fromJson(Map<String, dynamic> json) {
    var ayatList = json['ayat'] as List? ?? [];
    List<Ayat> ayatObjects = ayatList.map((a) => Ayat.fromJson(a)).toList();

    return SurahDetail(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
      tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      deskripsi: json['deskripsi'] ?? '',
      ayat: ayatObjects,
    );
  }
}

// Model data untuk merepresentasikan satu item Tafsir Ayat
class TafsirItem {
  final int ayat;
  final String teks;

  TafsirItem({
    required this.ayat,
    required this.teks,
  });

  // Membuat instance TafsirItem dari objek JSON API
  factory TafsirItem.fromJson(Map<String, dynamic> json) {
    return TafsirItem(
      ayat: json['ayat'],
      teks: json['teks'],
    );
  }
}

// Model data untuk merepresentasikan kumpulan Tafsir dari satu Surat penuh
class TafsirDetail {
  final int nomor;
  final String nama;
  final String namaLatin;
  final List<TafsirItem> tafsir;

  TafsirDetail({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.tafsir,
  });

  // Membuat instance TafsirDetail dari objek JSON API
  factory TafsirDetail.fromJson(Map<String, dynamic> json) {
    var tafsirList = json['tafsir'] as List? ?? [];
    List<TafsirItem> tafsirObjects = tafsirList.map((t) => TafsirItem.fromJson(t)).toList();

    return TafsirDetail(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      tafsir: tafsirObjects,
    );
  }
}
