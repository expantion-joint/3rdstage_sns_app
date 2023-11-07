import { Turbo } from "@hotwired/turbo-rails";
Turbo.session.drive = false;

const DB_NAME = 'previewImagesDB';
const STORE_NAME = 'images';
let db;

function openDatabase(callback) {
  const request = indexedDB.open(DB_NAME, 1);

  request.onupgradeneeded = function(event) {
    const db = event.target.result;
    db.createObjectStore(STORE_NAME);
  };

  request.onsuccess = function(event) {
    db = event.target.result;
    callback && callback();
  };

  request.onerror = function(event) {
    console.error("Error opening IndexedDB:", event);
  };
}

function saveImage(key, data) {
  const transaction = db.transaction([STORE_NAME], 'readwrite');
  const store = transaction.objectStore(STORE_NAME);
  store.put(data, key);
}

function loadImage(key, callback) {
  const transaction = db.transaction([STORE_NAME], 'readonly');
  const store = transaction.objectStore(STORE_NAME);
  const request = store.get(key);

  request.onsuccess = function(event) {
    callback && callback(event.target.result);
  };
}

document.addEventListener("turbo:load", function() {
  openDatabase(function() {
    const imageUpload = document.getElementById('imageUpload');
    imageUpload.addEventListener('change', function() {
      const file = this.files[0];
      if (file) {
        const reader = new FileReader();
        const imagePreview = document.getElementById('imagePreview');
        const imagePreviewImage = imagePreview.querySelector('.image-preview__image');
        const imagePreviewDefaultText = imagePreview.querySelector('.image-preview__default-text');

        imagePreviewImage.style.display = "block";
        imagePreviewDefaultText.style.display = "none";

        reader.addEventListener("load", function() {
          imagePreviewImage.setAttribute("src", this.result);
          saveImage('previewImage', this.result);
        });

        reader.readAsDataURL(file);
      }
    });
  });
});

document.addEventListener("DOMContentLoaded", function() {
  // 検証用
  console.log('---- app open ----');
  openDatabase(function() {
    const imagePreview = document.getElementById('imageComfirmPreview');
    if (imagePreview) {
      loadImage('previewImage', function(imageData) {
        console.log(imageData);
        imagePreview.setAttribute('src', imageData);
      });
    }
  });
});