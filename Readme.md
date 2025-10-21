# 🤖 GoGem Content-Based Recommender Model Documentation

## 📊 Evaluasi Model

- **MAE (normalisasi)** : 0.0223  
- **MAE (skala rating)** : 0.0892 (≈ 0.09 poin rating)  
- **Perkiraan Akurasi** : 97.77%  

---

## 🧠 Deskripsi Singkat

Model rekomendasi ini dikembangkan menggunakan pendekatan **Content-Based Filtering**, yang merekomendasikan destinasi wisata berdasarkan kesamaan konten seperti kategori wisata, lokasi, deskripsi, dan rating pengguna.

Model ini merupakan bagian dari Capstone Project **GoGem – Discover Hidden Gems & Local Wonders**, yang menjadi fitur utama sistem rekomendasi personal di dalam aplikasi Flutter kami.

---

## ⚙️ Arsitektur Model

Model ini menggunakan pipeline sederhana berbasis analisis teks dan representasi vektor konten destinasi wisata. Langkah utamanya meliputi:

1. **Preprocessing data**  
   Membersihkan data teks (nama destinasi, kategori, deskripsi) dan mengubahnya menjadi format numerik.

2. **Feature extraction (TF-IDF Vectorization)**  
   Menggunakan *TF-IDF* untuk mengekstrak fitur dari deskripsi dan kategori destinasi wisata.

3. **Similarity computation**  
   Menghitung kesamaan antar destinasi menggunakan *cosine similarity*.

4. **Ranking & recommendation**  
   Sistem mengurutkan destinasi berdasarkan tingkat kesamaan dengan preferensi pengguna dan menampilkan 5–10 rekomendasi teratas.

---

## 🧩 Dataset

Dataset yang digunakan mencakup:

- Nama destinasi wisata  
- Lokasi (kota/provinsi)  
- Kategori (kuliner, alam, budaya, hidden gem, UMKM)  
- Rating pengguna  
- Deskripsi singkat  

**Data dikumpulkan dari:**  
- Portal resmi pariwisata Indonesia  
- Google Maps (rating & ulasan)  
- Open dataset publik (Kaggle dan sumber terbuka lainnya)

---

## 🧮 Metodologi Pelatihan

- **Metode:** Content-Based Filtering (TF-IDF + Cosine Similarity)  
- **Framework:** Python (scikit-learn, pandas, numpy)

**Langkah utama:**  
1. Ekstraksi fitur teks menggunakan `TfidfVectorizer`  
2. Perhitungan *cosine similarity matrix*  
3. Evaluasi menggunakan subset validasi rating pengguna  
4. Pengujian terhadap input pengguna berupa destinasi favorit atau deskripsi preferensi

---

## 📈 Hasil Evaluasi

| Metrik | Nilai |
|:-------|:------:|
| MAE (normalisasi) | 0.0223 |
| MAE (skala rating) | 0.0892 |
| Akurasi estimasi preferensi | 97.77% |

Model memberikan rekomendasi dengan error yang sangat rendah (≈ 0.09 poin dari skala rating), menandakan sistem dapat memprediksi kesesuaian destinasi dengan preferensi pengguna dengan baik.

---

## 🧠 Contoh Output Rekomendasi

**Input pengguna:**  
> “Saya suka tempat alam yang tenang dan punya pemandangan air terjun.”

**Top 5 Rekomendasi:**  
1. Air Terjun Gitgit – Bali  
2. Curug Cimahi – Bandung  
3. Coban Rondo – Malang  
4. Tumpak Sewu – Lumajang  
5. Lembah Harau – Sumatera Barat  

---

## 🔍 Visualisasi Kesamaan Konten

Model menghasilkan matriks kesamaan (*similarity matrix*) yang divisualisasikan untuk menunjukkan tingkat kemiripan antar destinasi wisata. Setiap baris dan kolom mewakili destinasi, dengan warna intens menunjukkan tingkat kesamaan yang lebih tinggi.

---

## 🧩 Integrasi dengan Aplikasi Flutter

Model ini diintegrasikan ke aplikasi Flutter **GoGem** melalui backend Firebase dan API internal:

- Flutter memanggil API rekomendasi berdasarkan preferensi pengguna atau riwayat pencarian.  
- Hasil rekomendasi dikirim kembali sebagai daftar destinasi dengan detail (nama, lokasi, gambar, dan jarak).  
- Komponen UI menampilkan hasil dalam bentuk *Recommendation Card* interaktif.

---

## 🧰 Dependensi Teknis

- Python 3.10+  
- Pandas  
- NumPy  
- Scikit-learn  
- Matplotlib (opsional, untuk visualisasi)
