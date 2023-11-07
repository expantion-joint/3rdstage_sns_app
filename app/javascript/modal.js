document.addEventListener('DOMContentLoaded', (event) => {
  // モーダルを開くボタンを全て取得
  const buttons = document.querySelectorAll('.js-button');

  buttons.forEach(button => {
    button.addEventListener('click', (e) => {
      //　検証用
      console.log('---- modal open ----');
      // ボタンのdata-target属性からモーダルのIDを取得
      const target = button.dataset.target;
      // モーダルを表示
      document.querySelector(target).style.display = 'block';
    });
  });

  // モーダルを閉じるボタンを全て取得
  const closeButtons = document.querySelectorAll('.js-close-button');

  closeButtons.forEach(button => {
    button.addEventListener('click', (e) => {
      //　検証用
      console.log('---- modal close ----');
      // ボタンが含まれるモーダルを非表示
      button.closest('.js-modal').style.display = 'none';
    });
  });
});