// product_list.dart
class ProductData {
  static final List<Map<String, String>> popularProduct = [
    {
      "name": "Indomie Goreng",
      "price": "Rp. 3.000",
      "image": "assets/indomie_goreng.jpeg",
      "description":
          "Indomie Goreng adalah produk makanan instan yang terbuat dari bahan-bahan berkualitas tinggi.",
      "sold": "3960000"
    },
    {
      "name": "Kopi Kapal Api",
      "price": "Rp. 5.000",
      "image": "assets/kopi_kapal_api.jpeg",
      "description":
          "Kopi Kapal Api, kopi hitam dengan rasa autentik yang dinikmati banyak orang.",
      "sold": "5000"
    },
    {
      "name": "Tepung Terigu Segitiga Biru",
      "price": "Rp. 10.000",
      "image": "assets/tepung_segitiga_biru.jpeg",
      "description":
          "Tepung terigu berkualitas yang cocok untuk semua jenis masakan dan kue.",
      "sold": "12000"
    },
    {
      "name": "Gula Pasir Gulaku",
      "price": "Rp. 12.000",
      "image": "assets/gula_pasir_gulaku.jpeg",
      "description":
          "Gulaku adalah gula pasir berkualitas tinggi yang manis alami.",
      "sold": "300"
    },
    {
      "name": "Minyak Goreng Bimoli",
      "price": "Rp. 28.000",
      "image": "assets/minyak_goreng_bimoli.jpeg",
      "description":
          "Minyak goreng Bimoli, pilihan terbaik untuk menggoreng dengan hasil yang renyah.",
      "sold": "15000"
    },
    {
      "name": "Sabun Mandi Lifebuoy",
      "price": "Rp. 7.000",
      "image": "assets/sabun_mandi_lifebuoy.jpeg",
      "description":
          "Sabun Lifebuoy memberikan perlindungan dari kuman dengan wangi yang menyegarkan.",
      "sold": "800"
    },
    {
      "name": "Shampo Pantene",
      "price": "Rp. 15.000",
      "image": "assets/shampoo_pantene.jpeg",
      "description":
          "Pantene membantu merawat rambut agar tetap sehat dan berkilau.",
      "sold": "22000"
    },
    {
      "name": "Pasta Gigi Pepsodent",
      "price": "Rp. 8.000",
      "image": "assets/pasta_gigi_pepsodent.jpg",
      "description":
          "Pepsodent memberikan perlindungan terbaik untuk gigi dan gusi.",
      "sold": "500"
    },
    {
      "name": "Susu UHT Ultra Milk",
      "price": "Rp. 6.000",
      "image": "assets/susu_uht_ultramilk.png",
      "description":
          "Susu Ultra Milk segar dan bergizi, cocok untuk konsumsi sehari-hari.",
      "sold": "3200"
    },
    {
      "name": "Cokelat SilverQueen",
      "price": "Rp. 20.000",
      "image": "assets/coklat_silverqueen.jpg",
      "description":
          "SilverQueen cokelat premium dengan rasa yang nikmat dan lezat.",
      "sold": "7500"
    },
    {
      "name": "Air Mineral Aqua",
      "price": "Rp. 3.500",
      "image": "assets/air_mineral_aqua.jpg",
      "description":
          "Aqua, air mineral yang bersih dan menyegarkan dari sumber alami.",
      "sold": "25000"
    },
    {
      "name": "Teh Botol Sosro",
      "price": "Rp. 4.000",
      "image": "assets/teh_botol_sosro.jpeg",
      "description":
          "Teh Botol Sosro, teh manis alami dalam kemasan yang praktis.",
      "sold": "8000"
    },
    {
      "name": "Biskuit Roma Kelapa",
      "price": "Rp. 9.000",
      "image": "assets/biskuit_roma_kelapa.jpg",
      "description":
          "Biskuit Roma Kelapa dengan rasa kelapa gurih yang cocok sebagai cemilan.",
      "sold": "220"
    },
    {
      "name": "Mi Sedap Ayam Bawang",
      "price": "Rp. 2.800",
      "image": "assets/mie_sedap_ayam_bawang.jpg",
      "description":
          "Mi instan dengan rasa ayam bawang yang nikmat dan kaya akan rempah.",
      "sold": "150"
    },
    {
      "name": "Kecap Manis ABC",
      "price": "Rp. 7.000",
      "image": "assets/kecap_manis_abc.jpeg",
      "description":
          "Kecap Manis ABC memberikan cita rasa manis yang pas untuk berbagai masakan.",
      "sold": "19000"
    },
    {
      "name": "Sari Roti Tawar",
      "price": "Rp. 13.000",
      "image": "assets/sari_roti_tawar.jpeg",
      "description":
          "Sari Roti tawar yang lembut dan cocok untuk berbagai macam olahan roti.",
      "sold": "120"
    },
    {
      "name": "Sosis So Nice",
      "price": "Rp. 15.000",
      "image": "assets/sosis_sonice.jpg",
      "description":
          "So Nice sosis daging berkualitas dengan rasa gurih dan lezat.",
      "sold": "1100"
    },
    {
      "name": "Susu Kental Manis Indomilk",
      "price": "Rp. 8.000",
      "image": "assets/susu_kental_manis_indomilk.jpeg",
      "description":
          "Susu Kental Manis Indomilk untuk tambahan rasa manis pada berbagai olahan.",
      "sold": "950"
    },
    {
      "name": "Coca Cola 1L",
      "price": "Rp. 9.000",
      "image": "assets/coca_cola_1liter.jpg",
      "description":
          "Coca Cola, minuman bersoda dengan rasa klasik yang menyegarkan.",
      "sold": "2400"
    },
    {
      "name": "Keju Kraft Cheddar",
      "price": "Rp. 20.000",
      "image": "assets/keju_kraft_cheddar.jpeg",
      "description":
          "Keju Kraft Cheddar dengan tekstur lembut dan rasa gurih yang nikmat.",
      "sold": "200"
    },
  ];

  static String formatSold(String sold) {
    // Mengkonversi string ke integer
    final soldInt = int.tryParse(sold) ?? 0;

    if (soldInt >= 1000000000) {
      // Miliar
      return '${(soldInt / 1000000000).floor()}.${((soldInt % 1000000000) / 100000000).floor()}jt'; // Misal 1,0jt
    } else if (soldInt >= 1000000) {
      // Juta
      return '${(soldInt / 1000000).floor()}.${((soldInt % 1000000) / 100000).floor()}jt'; // Misal 1,8jt
    } else if (soldInt >= 1000) {
      // Ribu
      return '${(soldInt / 1000).floor()}rb'; // Ribu
    } else {
      return sold; // Tampilkan angka asli
    }
  }
}
