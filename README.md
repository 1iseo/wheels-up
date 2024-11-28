# wheels-up

## Struktur Folder
- app -> Aplikasi Flutter utama.
- backend-v2 -> Backend API untuk aplikasi wheels-up.
- docs -> Dokumen-dokumen yang ada.

## Cara menjalankan development server dan app
1. Run backend-v2  
1.1 Masuk ke folder backend-v2  
`cd backend-v2`  
1.2 Install dependencies  
`npm install`  
1.3 Buat file .env untuk konfigurasi database (lihat file .env.example untuk contoh)  
1.4 Run migration    
`node ace migration:run`  
1.5 Start development server  
`npm run dev`

2. Run flutter app  
2.1 Masuk ke folder app/wheels-up  
`cd app/wheels-up`  
2.2 Install dependencies    
`flutter pub get`  
2.3 Edit API base url (jika diperlukan, default localhost:3333)  
2.4 Run app  
`flutter run`  

